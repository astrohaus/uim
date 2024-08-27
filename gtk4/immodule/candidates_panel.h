#ifndef UIM_GTK4_IMMODULE_CANDIDATES_PANEL_H
#define UIM_GTK4_IMMODULE_CANDIDATES_PANEL_H

#include <gtk/gtk.h>
#include "uim/uim.h"

typedef struct _candidates_panel {
  GtkWidget *client;
  uint candiadates_count;
  uint candidates_per_page;
  uint current_page;

  guint signal_candidate_selector_show;
  guint signal_candidate_selector_select;
  guint signal_candidate_selector_hide;
} candidates_panel;

enum {
  CANDIDATES_PANEL_PAGE_DIRECTION_PREV = 0,
  CANDIDATES_PANEL_PAGE_DIRECTION_NEXT = 1
};

void candidates_panel_register_client(candidates_panel *panel, GtkWidget *client);
void candidates_panel_activate(
  candidates_panel *panel,
  uim_context uim_context,
  uint count,
  uint candidates_per_page);
void candidates_panel_select_candidate(
  candidates_panel *panel,
  uim_context uim_context,
  uint global_index);
void candidates_panel_shift_page(
  candidates_panel *panel,
  uim_context uim_context,
  int direction);
void candidates_panel_deactivate(candidates_panel *panel);

#endif
