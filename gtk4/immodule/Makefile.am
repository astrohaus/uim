uim_gtk4_im_module_path = $(libdir)/gtk-4.0

moduledir = $(uim_gtk4_im_module_path)/@GTK4_BINARY_VERSION@/immodules

if GTK4
libim_uim_la = libim-uim.la
libim_uim_la_CPPFLAGS = -I$(top_srcdir) -I$(top_builddir)
libim_uim_la_CFLAGS = @GTK4_CFLAGS@
module_LTLIBRARIES = $(libim_uim_la)


libim_uim_la_SOURCES = $(IM_UIM_SOURCES)
libim_uim_la_LDFLAGS = -module -avoid-version
libim_uim_la_LIBADD = $(top_builddir)/uim/libuim-scm.la \
		   $(top_builddir)/uim/libuim.la \
		   $(top_builddir)/uim/libuim-counted-init.la
if LIBUIM_X_UTIL
libim_uim_la_LIBADD += $(top_builddir)/uim/libuim-x-util.la
endif
libim_uim_la_LIBADD += @GTK4_LIBS@
libim_uim_la_LIBADD += -lm


IM_UIM_SOURCES = \
  gtk-im-uim.c gtk-im-uim.h \
  keyutil.c keyutil.h \
  preedit.c preedit.h \
  candidates_panel.c candidates_panel.h

else
install-data-hook:

uninstall-hook:

endif
