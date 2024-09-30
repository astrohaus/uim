#include <config.h>

#include <gtk/gtk.h>

#include "uim/uim.h"

#include "preedit.h"
#include "candidates_panel.h"

typedef struct _UIMIMContextClass {
  struct _GtkIMContextClass parent_class;
} UIMIMContextClass;

typedef struct _UIMIMContext {
  struct _GtkIMContext parent;
  struct _GtkIMContext *slave;
  uim_context uim_context;
  GtkWidget *widget;

  preedit preedit;
  candidates_panel candidates_panel;
  unsigned int g_io_channel_read_tag;
} UIMIMContext;

GType uim_im_context_get_type(void);
