/*
 * Copyright (c) 2004 Iwata <iwata@quasiquote.org>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

#ifndef UIM_NOTIFY_H
#define UIM_NOTIFY_H

#ifdef __cplusplus
extern "C" {
#endif

#define NOTIFY_PLUGIN_PREFIX "libuimnotify-"
#define NOTIFY_PLUGIN_SUFFIX ".so"

#define NOTIFY_PLUGIN_PATH LIBDIR "/uim/notify"

int uim_notify_load(const char *);
int uim_notify_init(void);
void uim_notify_quit(void);
int uim_notify_info(const char *, ...);
int uim_notify_fatal(const char *, ...);

#ifdef __cplusplus
}
#endif

#endif
