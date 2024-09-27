#include <gtk/gtk.h>

#include "uim/uim.h"

#include "candidates_panel.h"

static void _show_current_page(candidates_panel *panel, uim_context uim_context);
static bool _current_page_is_first(candidates_panel *panel);
static bool _current_page_is_last(candidates_panel *panel);
static void _select_first_candidate_on_current_page(candidates_panel *panel, uim_context uim_context);
static void _select_last_candidate_on_current_page(candidates_panel *panel, uim_context uim_context);

void
candidates_panel_register_client(candidates_panel *panel, GtkWidget *client)
{
  candidates_panel_deactivate(panel);
  panel->client = client;
  if (client) {
    panel->signal_candidate_selector_show = g_signal_lookup(
      "im-candidate-selector-show",
      G_OBJECT_TYPE(client));
    panel->signal_candidate_selector_select = g_signal_lookup(
      "im-candidate-selector-select",
      G_OBJECT_TYPE(client));
    panel->signal_candidate_selector_hide = g_signal_lookup(
      "im-candidate-selector-hide",
      G_OBJECT_TYPE(client));
  }
}

void
candidates_panel_activate(
  candidates_panel *panel,
  uim_context uim_context,
  uint count,
  uint candidates_per_page)
{
  panel->candiadates_count = count;
  panel->candidates_per_page = candidates_per_page;
  panel->current_page = 0;

  _show_current_page(panel, uim_context);
}

void
candidates_panel_select_candidate(
  candidates_panel *panel,
  uim_context uim_context,
  uint global_index)
{
  if (panel->client == NULL) return;
  if (panel->signal_candidate_selector_select == 0) return;

  uint page = global_index / panel->candidates_per_page;
  if (page != panel->current_page) {
    panel->current_page = page;
    _show_current_page(panel, uim_context);
  }
  g_signal_emit(
    panel->client,
    panel->signal_candidate_selector_select,
    0,
    global_index % panel->candidates_per_page);
}

void
candidates_panel_shift_page(
  candidates_panel *panel,
  uim_context uim_context,
  int direction)
{
  if (panel->client == NULL) return;

  if (direction == CANDIDATES_PANEL_PAGE_DIRECTION_PREV) {
    if (_current_page_is_first(panel)) {
      _select_first_candidate_on_current_page(panel, uim_context);
    } else {
      panel->current_page--;
      _show_current_page(panel, uim_context);
      _select_last_candidate_on_current_page(panel, uim_context);
    }
  }
  else if (direction == CANDIDATES_PANEL_PAGE_DIRECTION_NEXT) {
    if (_current_page_is_last(panel)) {
      _select_last_candidate_on_current_page(panel, uim_context);
    } else {
      panel->current_page++;
      _show_current_page(panel, uim_context);
      _select_first_candidate_on_current_page(panel, uim_context);
    }
  }
}

void
candidates_panel_deactivate(candidates_panel *panel)
{
  if (panel->client == NULL) return;
  if (panel->signal_candidate_selector_hide == 0) return;

  g_signal_emit(
    panel->client,
    panel->signal_candidate_selector_hide,
    0);
}

static void _show_current_page(candidates_panel *panel, uim_context uim_context)
{
  if (panel->client == NULL) return;
  if (uim_context == NULL) return;
  if (panel->signal_candidate_selector_show == 0) return;

  uint start_index = panel->current_page * panel->candidates_per_page;
  uint end_index = start_index + panel->candidates_per_page;
  if (end_index > panel->candiadates_count) {
    end_index = panel->candiadates_count;
  }

  GStrvBuilder *candidate_labels = g_strv_builder_new();
  for (uint i = start_index; i < end_index; i++) {
    uim_candidate candidate = uim_get_candidate(uim_context, i, i % panel->candidates_per_page);
    const char *label = uim_candidate_get_cand_str(candidate);
    g_strv_builder_add(candidate_labels, label);
    uim_candidate_free(candidate);
  }

  g_signal_emit(
    panel->client,
    panel->signal_candidate_selector_show,
    0,
    end_index - start_index,
    g_strv_builder_end(candidate_labels),
    panel->current_page > 0,
    panel->current_page < (panel->candiadates_count - 1) / panel->candidates_per_page);

  g_strv_builder_unref(candidate_labels);
}

static bool
_current_page_is_first(candidates_panel *panel)
{
  return panel->current_page == 0;
}

static bool
_current_page_is_last(candidates_panel *panel)
{
  return panel->current_page == (panel->candiadates_count - 1) / panel->candidates_per_page;
}

static void
_select_first_candidate_on_current_page(candidates_panel *panel, uim_context uim_context)
{
  uim_set_candidate_index(uim_context, panel->current_page * panel->candidates_per_page);
  candidates_panel_select_candidate(panel, uim_context, panel->current_page * panel->candidates_per_page);
}

static void
_select_last_candidate_on_current_page(candidates_panel *panel, uim_context uim_context)
{
  uint last_index = panel->current_page * panel->candidates_per_page + panel->candidates_per_page - 1;
  if (last_index >= panel->candiadates_count) {
    last_index = panel->candiadates_count - 1;
  }
  uim_set_candidate_index(uim_context, last_index);
  candidates_panel_select_candidate(panel, uim_context, last_index);
}
