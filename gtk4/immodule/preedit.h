#ifndef UIM_GTK_PREEDIT_H
#define UIM_GTK_PREEDIT_H

typedef struct _preedit_segment {
  int attr;
  gchar *str;
} preedit_segment;

typedef struct _preedit {
  int segments_count;
  preedit_segment *segments;
  int last_strlen;
} preedit;

void preedit_init(preedit *preedit);
void preedit_clear(preedit *preedit);
void preedit_add_segment(preedit *preedit, const char *str, int attr);
int preedit_strlen(preedit *preedit);

inline int preedit_last_strlen(preedit *preedit) {
  return preedit->last_strlen;
}

inline void preedit_set_last_strlen(preedit *preedit, int len) {
  preedit->last_strlen = len;
}

void
preedit_match_gtk_im_module_preedit_string(
  preedit *preedit,
  gchar **str,
  PangoAttrList **attrs,
  gint *cursor_pos);

#endif
