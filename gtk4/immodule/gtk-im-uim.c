#include <config.h>

#include <gtk/gtk.h>
#include <gtk/gtkimmodule.h>

#include <locale.h>

#include "uim/uim.h"
#include "uim/uim-util.h"
#include "uim/counted-init.h"
#include "uim/uim-helper.h"
#include "uim/uim-im-switcher.h"

#include "gtk-im-uim.h"
#include "keyutil.h"
#include "candidates_panel.h"
#include "preedit.h"

#define UIM_IM_CONTEXT(obj) (G_TYPE_CHECK_INSTANCE_CAST((obj),uim_im_context_get_type(),UIMIMContext))

G_DEFINE_DYNAMIC_TYPE(UIMIMContext, uim_im_context, GTK_TYPE_IM_CONTEXT)

static void uim_im_context_dispose(GObject *object);
static void uim_im_context_finalize(GObject *object);

static gboolean uim_im_context_filter_keypress(GtkIMContext *context, GdkEvent *event);
static void uim_im_context_get_preedit_string(
  GtkIMContext *context, gchar **str, PangoAttrList **attrs, gint *cursor_pos);
static void uim_im_context_set_client_widget(GtkIMContext *context, GtkWidget *widget);
static void uim_im_context_focus_in(GtkIMContext *context);
static void uim_im_context_focus_out(GtkIMContext *context);

static void _uim_im_slave_im_context_commit_callback(
  GtkIMContext *slave,
  const gchar *str,
  UIMIMContext *context);
static void _uim_im_uim_commit_callback(void *ptr, const char *str);
static void _uim_im_uim_candidate_selector_activate_callback(void *ptr, int nr, int display_limit);
static void _uim_im_uim_candidate_selector_select_callback(void *ptr, int index);
static void _uim_im_uim_candidate_selector_shift_page_callback(void *ptr, int direction);
static void _uim_im_uim_candidate_selector_deactivate_callback(void *ptr);
static void _uim_im_uim_preedit_clear_callback(void *ptr);
static void _uim_im_uim_preedit_pushback_callback(void *ptr, int attr, const char *str);
static void _uim_im_uim_preedit_update_callback(void *ptr);

static int _uim_im_uim_fd = -1;
static void _uim_im_ensure_uim_helper_connection(UIMIMContext *uic);
static void _uim_im_uim_helper_disconnect_cb(void);
static gboolean _uim_im_uim_helper_read_cb(
  GIOChannel *channel,
  GIOCondition condition,
  gpointer data);


static void
uim_im_context_class_init(UIMIMContextClass *class)
{
  GtkIMContextClass *im_context_class = GTK_IM_CONTEXT_CLASS(class);
  im_context_class->set_client_widget = uim_im_context_set_client_widget;
  im_context_class->filter_keypress = uim_im_context_filter_keypress;
  im_context_class->get_preedit_string = uim_im_context_get_preedit_string;
  im_context_class->focus_in = uim_im_context_focus_in;
  im_context_class->focus_out = uim_im_context_focus_out;

  GObjectClass *gobject_class = G_OBJECT_CLASS(class);
  gobject_class->dispose = uim_im_context_dispose;
  gobject_class->finalize = uim_im_context_finalize;
}

static void uim_im_context_class_finalize(UIMIMContextClass *class)
{
}

static void
uim_im_context_init(UIMIMContext *uic)
{
  uic->widget = NULL;

  uic->slave = gtk_im_context_simple_new();
  g_signal_connect(
    G_OBJECT(uic->slave),
    "commit",
    G_CALLBACK(_uim_im_slave_im_context_commit_callback),
    uic);

  preedit_init(&uic->preedit);

  const char *im_name = uim_get_default_im_name(setlocale(LC_CTYPE, NULL));
  uic->uim_context = uim_create_context(
    uic,
    "UTF-8",
    NULL,
    im_name,
    uim_iconv,
    _uim_im_uim_commit_callback);

  uim_set_candidate_selector_cb(
    uic->uim_context,
    _uim_im_uim_candidate_selector_activate_callback,
    _uim_im_uim_candidate_selector_select_callback,
    _uim_im_uim_candidate_selector_shift_page_callback,
    _uim_im_uim_candidate_selector_deactivate_callback);

  uim_set_preedit_cb(
    uic->uim_context,
    _uim_im_uim_preedit_clear_callback,
    _uim_im_uim_preedit_pushback_callback,
    _uim_im_uim_preedit_update_callback);

  _uim_im_ensure_uim_helper_connection(uic);
  keyutil_init_modifier_keys();
}

static void
_uim_im_slave_im_context_commit_callback(
  GtkIMContext *slave,
  const gchar *str,
  UIMIMContext *uic)
{
  g_return_if_fail(str);
  g_signal_emit_by_name(uic, "commit", str);
}

static void
_uim_im_uim_commit_callback(void *ptr, const char *str)
{
  UIMIMContext *uic = (UIMIMContext *)ptr;
  g_return_if_fail(str);
  g_signal_emit_by_name(uic, "commit", str);
}

static void
_uim_im_uim_candidate_selector_activate_callback(void *ptr, int nr, int display_limit) {
  UIMIMContext *uic = (UIMIMContext *)ptr;

  candidates_panel_activate(
    &uic->candidates_panel,
    uic->uim_context,
    nr,
    display_limit
  );
}

static void
_uim_im_uim_candidate_selector_select_callback(void *ptr, int index) {
  UIMIMContext *uic = (UIMIMContext *)ptr;

  candidates_panel_select_candidate(&uic->candidates_panel, uic->uim_context, index);
}

static void
_uim_im_uim_candidate_selector_shift_page_callback(void *ptr, int direction) {
  UIMIMContext *uic = (UIMIMContext *)ptr;

  candidates_panel_shift_page(&uic->candidates_panel, uic->uim_context, direction);
}

static void
_uim_im_uim_candidate_selector_deactivate_callback(void *ptr) {
  UIMIMContext *uic = (UIMIMContext *)ptr;

  candidates_panel_deactivate(&uic->candidates_panel);
}

static void
_uim_im_uim_preedit_clear_callback(void *ptr) {
  UIMIMContext *uic = (UIMIMContext *)ptr;
  preedit_clear(&uic->preedit);
}

static void
_uim_im_uim_preedit_pushback_callback(void *ptr, int attr, const char *str) {
  UIMIMContext *uic = (UIMIMContext *)ptr;
  g_return_if_fail(str);

  if (strlen(str) > 0 || attr & (UPreeditAttr_Cursor | UPreeditAttr_Separator)) {
    preedit_add_segment(&uic->preedit, str, attr);
  }
}

static void
_uim_im_uim_preedit_update_callback(void *ptr) {
  UIMIMContext *uic = (UIMIMContext *)ptr;
  g_return_if_fail(uic);

  int preedit_str_len = preedit_strlen(&uic->preedit);

  if (preedit_last_strlen(&uic->preedit) == 0 && preedit_str_len > 0) {
    g_signal_emit_by_name(uic, "preedit_start");
  }
  if (preedit_last_strlen(&uic->preedit) > 0 || preedit_str_len > 0) {
    g_signal_emit_by_name(uic, "preedit_changed");
  }
  if (preedit_last_strlen(&uic->preedit) > 0 && preedit_str_len == 0) {
    g_signal_emit_by_name(uic, "preedit_end");
  }
  preedit_set_last_strlen(&uic->preedit, preedit_str_len);
}

static void
_uim_im_ensure_uim_helper_connection(UIMIMContext *uic)
{
  if (_uim_im_uim_fd < 0) {
    _uim_im_uim_fd = uim_helper_init_client_fd(_uim_im_uim_helper_disconnect_cb);
  }
  if (_uim_im_uim_fd >= 0) {
    uim_set_uim_fd(uic->uim_context, _uim_im_uim_fd);
    GIOChannel *channel = g_io_channel_unix_new(_uim_im_uim_fd);
    uic->g_io_channel_read_tag = g_io_add_watch(
      channel,
      G_IO_IN | G_IO_HUP | G_IO_ERR,
      _uim_im_uim_helper_read_cb,
      uic->uim_context);
    g_io_channel_unref(channel);
  }
}

static void _uim_im_uim_helper_disconnect_cb(void)
{
  _uim_im_uim_fd = -1;
}

static gboolean _uim_im_uim_helper_read_cb(
  GIOChannel *channel,
  GIOCondition condition,
  gpointer uim_context)
{
  if (condition & G_IO_IN) {
    int fd = g_io_channel_unix_get_fd(channel);
    uim_helper_read_proc(fd);
    char *msg;
    while ((msg = uim_helper_get_message())) {
      if (g_str_has_prefix(msg, "im_change_whole_desktop") == TRUE) {
        gchar **lines = g_strsplit(msg, "\n", -1);
        gchar *im_name = lines[1];

        uim_switch_im(uim_context, im_name);
        uim_prop_update_custom(
          uim_context,
          "custom-preserved-default-im-name",
          im_name
        );
        uim_prop_list_update(uim_context);
      }

      free(msg);
    }
  }
  return TRUE;
}

static void
uim_im_context_dispose(GObject *object)
{
  UIMIMContext *uic = UIM_IM_CONTEXT(object);

  if (uic->slave) {
    g_signal_handlers_disconnect_by_func(
      uic->slave,
      (gpointer)(uintptr_t)_uim_im_slave_im_context_commit_callback,
      uic);
    g_object_unref(uic->slave);
    uic->slave = NULL;
  }
  g_source_remove(uic->g_io_channel_read_tag);
  if (uic->uim_context) {
    uim_release_context(uic->uim_context);
    uic->uim_context = NULL;
  }
  G_OBJECT_CLASS(uim_im_context_parent_class)->dispose(object);
}

static void
uim_im_context_finalize(GObject *object)
{
  G_OBJECT_CLASS(uim_im_context_parent_class)->finalize(object);
}

static gboolean
uim_im_context_filter_keypress(GtkIMContext *context, GdkEvent *event)
{
  UIMIMContext *uic = UIM_IM_CONTEXT(context);
  int keycode, keystate;
  keyutil_convert_gdk_event_to_uim_key(event, &keycode, &keystate);
  if (gdk_event_get_event_type(event) == GDK_KEY_RELEASE) {
    if (uim_release_key(uic->uim_context, keycode, keystate)) {
      return gtk_im_context_filter_keypress(uic->slave, event);
    }
    return TRUE;
  }
  else if (gdk_event_get_event_type(event) == GDK_KEY_PRESS) {
    if (uim_press_key(uic->uim_context, keycode, keystate)) {
      return gtk_im_context_filter_keypress(uic->slave, event);
    }
    return TRUE;
  }
  else {
    return gtk_im_context_filter_keypress(uic->slave, event);
  }
}

static void uim_im_context_get_preedit_string(
  GtkIMContext *context,
  gchar **str,
  PangoAttrList **attrs,
  gint *cursor_pos)
{
  UIMIMContext *uic = UIM_IM_CONTEXT(context);
  preedit_match_gtk_im_module_preedit_string(
    &uic->preedit,
    str,
    attrs,
    cursor_pos);
}

static void
uim_im_context_set_client_widget(GtkIMContext *context, GtkWidget *widget)
{
  UIMIMContext *uic = UIM_IM_CONTEXT(context);
  gtk_im_context_set_client_widget(uic->slave, widget);
  uic->widget = widget;
  candidates_panel_register_client(&uic->candidates_panel, widget);
}

static void
uim_im_context_focus_in(GtkIMContext *context) {
  UIMIMContext *uic = UIM_IM_CONTEXT(context);
  uim_focus_in_context(uic->uim_context);
}

static void
uim_im_context_focus_out(GtkIMContext *context) {
  UIMIMContext *uic = UIM_IM_CONTEXT(context);
  uim_focus_out_context(uic->uim_context);
}


/* GIO module */

void
g_io_module_load(GIOModule *module)
{
  if (uim_counted_init() == -1)
    return;

  g_type_module_use(G_TYPE_MODULE(module));
  uim_im_context_register_type(G_TYPE_MODULE(module));
  g_io_extension_point_implement(
    GTK_IM_MODULE_EXTENSION_POINT_NAME,
    uim_im_context_get_type(),
    "uim",
    0
  );
}

void
g_io_module_unload(GIOModule *module)
{
  if (_uim_im_uim_fd != -1) {
    uim_helper_close_client_fd(_uim_im_uim_fd);
    _uim_im_uim_fd = -1;
  }

  uim_counted_quit();
  g_type_module_unuse(G_TYPE_MODULE(module));
}
