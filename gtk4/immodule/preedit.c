#include <stdlib.h>
#include <string.h>

#include <gtk/gtk.h>
#include "uim/uim.h"

#include "preedit.h"

void
preedit_init(preedit *preedit) {
  preedit->segments_count = 0;
  preedit->segments = NULL;
  preedit->last_strlen = 0;
}

void
preedit_clear(preedit *preedit) {
  for (int i = 0; i < preedit->segments_count; i++) {
    g_free(preedit->segments[i].str);
  }
  if (preedit->segments) {
    free(preedit->segments);
  }
  preedit->segments = NULL;
  preedit->segments_count = 0;
}

void
preedit_add_segment(preedit *preedit, const char *str, int attr) {
  preedit->segments = realloc(
    preedit->segments,
    sizeof(preedit_segment) * (preedit->segments_count + 1));
  preedit->segments[preedit->segments_count].attr = attr;
  preedit->segments[preedit->segments_count].str = g_strdup(str);
  preedit->segments_count++;
}

int
preedit_strlen(preedit *preedit) {
  int len = 0;
  for (int i = 0; i < preedit->segments_count; i++) {
    len += strlen(preedit->segments[i].str);
  }
  return len;
}

void
preedit_match_gtk_im_module_preedit_string(
  preedit *preedit,
  gchar **return_str,
  PangoAttrList **return_attrs,
  gint *return_cursor_pos)
{
  gchar *str = g_strdup("");
  PangoAttrList *attrs = pango_attr_list_new();
  gint cursor_pos = 0;

  /* We don't support segment separator, input methods don't use it much */
  for (int i = 0; i < preedit->segments_count; i++) {
    if (preedit->segments[i].attr & UPreeditAttr_Cursor) {
      cursor_pos = g_utf8_strlen(str, -1);
    }

    int segment_length = strlen(preedit->segments[i].str);
    int segment_start = strlen(str);
    int segment_end = segment_start + segment_length;
    if (preedit->segments[i].attr & UPreeditAttr_UnderLine) {
      PangoAttribute *attr = pango_attr_underline_new(PANGO_UNDERLINE_SINGLE);
      attr->start_index = segment_start;
      attr->end_index = segment_end;
      pango_attr_list_change(attrs, attr);
    }
    if (strcmp(preedit->segments[i].str, "")) {
      str = (gchar *)g_realloc(str, segment_end + 1);
      g_strlcat(str, preedit->segments[i].str, segment_end + 1);
    }
  }

  if (return_str) {
    *return_str = str;
  } else {
    g_free(str);
  }
  if (return_attrs) {
    *return_attrs = attrs;
  } else {
    pango_attr_list_unref(attrs);
  }
  if (return_cursor_pos) {
    *return_cursor_pos = cursor_pos;
  }
}
