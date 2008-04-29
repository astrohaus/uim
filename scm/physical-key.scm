;;; physical-key.scm: Physical key definitions and utilities
;;;
;;; Copyright (c) 2005 uim Project http://uim.freedesktop.org/
;;;
;;; All rights reserved.
;;;
;;; Redistribution and use in source and binary forms, with or without
;;; modification, are permitted provided that the following conditions
;;; are met:
;;; 1. Redistributions of source code must retain the above copyright
;;;    notice, this list of conditions and the following disclaimer.
;;; 2. Redistributions in binary form must reproduce the above copyright
;;;    notice, this list of conditions and the following disclaimer in the
;;;    documentation and/or other materials provided with the distribution.
;;; 3. Neither the name of authors nor the names of its contributors
;;;    may be used to endorse or promote products derived from this software
;;;    without specific prior written permission.
;;;
;;; THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
;;; ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
;;; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
;;; ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
;;; FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
;;; DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
;;; OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
;;; HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
;;; LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
;;; OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
;;; SUCH DAMAGE.
;;;;

;; This file defines physical keyboard information such as
;; logical-physical key mappings. Future version of uim may contain
;; more information about keyboards such as dimensions and visual
;; attributes to provide visual input guidance, keymap editor, and so
;; on.  -- YamaKen 2005-02-12

(require "util.scm")
(require "ng-key.scm")
(require-custom "im-custom.scm")


(define lkey-qwerty->pkey-qwerty-alist
  '(
    (lkey_BackSpace   . pkey_qwerty_BackSpace)
    (lkey_Tab         . pkey_qwerty_Tab)
    (lkey_Return      . pkey_qwerty_Return)
    (lkey_Escape      . pkey_qwerty_Escape)
    (lkey_Delete      . pkey_qwerty_Delete)
    (lkey_Home        . pkey_qwerty_Home)
    (lkey_Left        . pkey_qwerty_Left)
    (lkey_Up          . pkey_qwerty_Up)
    (lkey_Right       . pkey_qwerty_Right)
    (lkey_Down        . pkey_qwerty_Down)
    (lkey_Page_Up     . pkey_qwerty_Page_Up)
    (lkey_Page_Down   . pkey_qwerty_Page_Down)
    (lkey_End         . pkey_qwerty_End)
    (lkey_Insert      . pkey_qwerty_Insert)
			   
    (lkey_Shift_L     . pkey_qwerty_Shift_L)
    (lkey_Shift_R     . pkey_qwerty_Shift_R)
    (lkey_Control_L   . pkey_qwerty_Control_L)
    (lkey_Control_R   . pkey_qwerty_Control_R)
    (lkey_Caps_Lock   . pkey_qwerty_Caps_Lock)
    ;;(lkey_Meta_L      . pkey_qwerty_Meta_L)
    ;;(lkey_Meta_R      . pkey_qwerty_Meta_R)
    (lkey_Alt_L       . pkey_qwerty_Alt_L)
    (lkey_Alt_R       . pkey_qwerty_Alt_R)
    ;;(lkey_Super_L     . pkey_qwerty_Super_L)
    ;;(lkey_Super_R     . pkey_qwerty_Super_R)
    ;;(lkey_Hyper_L     . pkey_qwerty_Hyper_L)
    ;;(lkey_Hyper_R     . pkey_qwerty_Hyper_R)

    (lkey_F1  . pkey_qwerty_F1)
    (lkey_F2  . pkey_qwerty_F2)
    (lkey_F3  . pkey_qwerty_F3)
    (lkey_F4  . pkey_qwerty_F4)
    (lkey_F5  . pkey_qwerty_F5)
    (lkey_F6  . pkey_qwerty_F6)
    (lkey_F7  . pkey_qwerty_F7)
    (lkey_F8  . pkey_qwerty_F8)
    (lkey_F9  . pkey_qwerty_F9)
    (lkey_F10 . pkey_qwerty_F10)
    (lkey_F11 . pkey_qwerty_F11)
    (lkey_F12 . pkey_qwerty_F12)
    (lkey_F13 . pkey_qwerty_F13)
    (lkey_F14 . pkey_qwerty_F14)
    (lkey_F15 . pkey_qwerty_F15)
    (lkey_F16 . pkey_qwerty_F16)
    (lkey_F17 . pkey_qwerty_F17)
    (lkey_F18 . pkey_qwerty_F18)
    (lkey_F19 . pkey_qwerty_F19)
    (lkey_F20 . pkey_qwerty_F20)
    (lkey_F21 . pkey_qwerty_F21)
    (lkey_F22 . pkey_qwerty_F22)
    (lkey_F23 . pkey_qwerty_F23)
    (lkey_F24 . pkey_qwerty_F24)
    (lkey_F25 . pkey_qwerty_F25)
    (lkey_F26 . pkey_qwerty_F26)
    (lkey_F27 . pkey_qwerty_F27)
    (lkey_F28 . pkey_qwerty_F28)
    (lkey_F29 . pkey_qwerty_F29)
    (lkey_F30 . pkey_qwerty_F30)
    (lkey_F31 . pkey_qwerty_F31)
    (lkey_F32 . pkey_qwerty_F32)
    (lkey_F33 . pkey_qwerty_F33)
    (lkey_F34 . pkey_qwerty_F34)
    (lkey_F35 . pkey_qwerty_F35)

    ;; ASCII keys
    (lkey_space        . pkey_qwerty_space)
    (lkey_exclam       . pkey_qwerty_1)
    (lkey_quotedbl     . pkey_qwerty_apostrophe)
    (lkey_numbersign   . pkey_qwerty_3)
    (lkey_dollar       . pkey_qwerty_4)
    (lkey_percent      . pkey_qwerty_5)
    (lkey_ampersand    . pkey_qwerty_7)
    (lkey_apostrophe   . pkey_qwerty_apostrophe)
    (lkey_parenleft    . pkey_qwerty_9)
    (lkey_parenright   . pkey_qwerty_0)
    (lkey_asterisk     . pkey_qwerty_8)
    (lkey_plus         . pkey_qwerty_equal)
    (lkey_comma        . pkey_qwerty_comma)
    (lkey_minus        . pkey_qwerty_minus)
    (lkey_period       . pkey_qwerty_period)
    (lkey_slash        . pkey_qwerty_slash)
    (lkey_0            . pkey_qwerty_0)
    (lkey_1            . pkey_qwerty_1)
    (lkey_2            . pkey_qwerty_2)
    (lkey_3            . pkey_qwerty_3)
    (lkey_4            . pkey_qwerty_4)
    (lkey_5            . pkey_qwerty_5)
    (lkey_6            . pkey_qwerty_6)
    (lkey_7            . pkey_qwerty_7)
    (lkey_8            . pkey_qwerty_8)
    (lkey_9            . pkey_qwerty_9)
    (lkey_colon        . pkey_qwerty_semicolon)
    (lkey_semicolon    . pkey_qwerty_semicolon)
    (lkey_less         . pkey_qwerty_comma)
    (lkey_equal        . pkey_qwerty_equal)
    (lkey_greater      . pkey_qwerty_period)
    (lkey_question     . pkey_qwerty_slash)
    (lkey_at           . pkey_qwerty_2)
    (lkey_A            . pkey_qwerty_a)
    (lkey_B            . pkey_qwerty_b)
    (lkey_C            . pkey_qwerty_c)
    (lkey_D            . pkey_qwerty_d)
    (lkey_E            . pkey_qwerty_e)
    (lkey_F            . pkey_qwerty_f)
    (lkey_G            . pkey_qwerty_g)
    (lkey_H            . pkey_qwerty_h)
    (lkey_I            . pkey_qwerty_i)
    (lkey_J            . pkey_qwerty_j)
    (lkey_K            . pkey_qwerty_k)
    (lkey_L            . pkey_qwerty_l)
    (lkey_M            . pkey_qwerty_m)
    (lkey_N            . pkey_qwerty_n)
    (lkey_O            . pkey_qwerty_o)
    (lkey_P            . pkey_qwerty_p)
    (lkey_Q            . pkey_qwerty_q)
    (lkey_R            . pkey_qwerty_r)
    (lkey_S            . pkey_qwerty_s)
    (lkey_T            . pkey_qwerty_t)
    (lkey_U            . pkey_qwerty_u)
    (lkey_V            . pkey_qwerty_v)
    (lkey_W            . pkey_qwerty_w)
    (lkey_X            . pkey_qwerty_x)
    (lkey_Y            . pkey_qwerty_y)
    (lkey_Z            . pkey_qwerty_z)
    (lkey_bracketleft  . pkey_qwerty_bracketleft)
    (lkey_backslash    . pkey_qwerty_backslash)
    (lkey_bracketright . pkey_qwerty_bracketright)
    (lkey_asciicircum  . pkey_qwerty_6)
    (lkey_underscore   . pkey_qwerty_minus)
    (lkey_grave        . pkey_qwerty_grave)
    (lkey_a            . pkey_qwerty_a)
    (lkey_b            . pkey_qwerty_b)
    (lkey_c            . pkey_qwerty_c)
    (lkey_d            . pkey_qwerty_d)
    (lkey_e            . pkey_qwerty_e)
    (lkey_f            . pkey_qwerty_f)
    (lkey_g            . pkey_qwerty_g)
    (lkey_h            . pkey_qwerty_h)
    (lkey_i            . pkey_qwerty_i)
    (lkey_j            . pkey_qwerty_j)
    (lkey_k            . pkey_qwerty_k)
    (lkey_l            . pkey_qwerty_l)
    (lkey_m            . pkey_qwerty_m)
    (lkey_n            . pkey_qwerty_n)
    (lkey_o            . pkey_qwerty_o)
    (lkey_p            . pkey_qwerty_p)
    (lkey_q            . pkey_qwerty_q)
    (lkey_r            . pkey_qwerty_r)
    (lkey_s            . pkey_qwerty_s)
    (lkey_t            . pkey_qwerty_t)
    (lkey_u            . pkey_qwerty_u)
    (lkey_v            . pkey_qwerty_v)
    (lkey_w            . pkey_qwerty_w)
    (lkey_x            . pkey_qwerty_x)
    (lkey_y            . pkey_qwerty_y)
    (lkey_z            . pkey_qwerty_z)
    (lkey_braceleft    . pkey_qwerty_bracketleft)
    (lkey_bar          . pkey_qwerty_backslash)
    (lkey_braceright   . pkey_qwerty_bracketright)
    (lkey_asciitilde   . pkey_qwerty_grave)
    ))

(define lkey-extended-qwerty->pkey-qwerty-alist
  (append
   lkey-qwerty->pkey-qwerty-alist
  '(
    (lkey_Multi_key   . pkey_qwerty_Multi_key)   ;; Multi-key character compose
    (lkey_Mode_switch . pkey_qwerty_Mode_switch) ;; Character set switch

    ;; dead keys: QWERTY keyboard does not have these keys
    ;;(lkey_dead_grave            . pkey_qwerty_grave)
    ;;(lkey_dead_acute            . pkey_qwerty_acute)
    ;;(lkey_dead_circumflex       . pkey_qwerty_circumflex)
    ;;(lkey_dead_tilde            . pkey_qwerty_tilde)
    ;;(lkey_dead_macron           . pkey_qwerty_macron)
    ;;(lkey_dead_breve            . pkey_qwerty_breve)
    ;;(lkey_dead_abovedot         . pkey_qwerty_abovedot)
    ;;(lkey_dead_diaeresis        . pkey_qwerty_diaeresis)
    ;;(lkey_dead_abovering        . pkey_qwerty_abovering)
    ;;(lkey_dead_doubleacute      . pkey_qwerty_doubleacute)
    ;;(lkey_dead_caron            . pkey_qwerty_caron)
    ;;(lkey_dead_cedilla          . pkey_qwerty_cedilla)
    ;;(lkey_dead_ogonek           . pkey_qwerty_ogonek)
    ;;(lkey_dead_iota             . pkey_qwerty_iota)
    ;;(lkey_dead_voiced_sound     . pkey_qwerty_voiced_sound)
    ;;(lkey_dead_semivoiced_sound . pkey_qwerty_semivoiced_sound)
    ;;(lkey_dead_belowdot         . pkey_qwerty_belowdot)
    ;;(lkey_dead_hook             . pkey_qwerty_hook)
    ;;(lkey_dead_horn             . pkey_qwerty_horn)
    )))

(define lkey-dvorak->pkey-qwerty-alist
  (append
   '(
     ;; ASCII keys
     ;(lkey_space        . pkey_qwerty_space)
     ;(lkey_exclam       . pkey_qwerty_1)
     (lkey_quotedbl     . pkey_qwerty_q)
     ;(lkey_numbersign   . pkey_qwerty_3)
     ;(lkey_dollar       . pkey_qwerty_4)
     ;(lkey_percent      . pkey_qwerty_5)
     ;(lkey_ampersand    . pkey_qwerty_7)
     (lkey_apostrophe   . pkey_qwerty_q)
     ;(lkey_parenleft    . pkey_qwerty_9)
     ;(lkey_parenright   . pkey_qwerty_0)
     ;(lkey_asterisk     . pkey_qwerty_8)
     (lkey_plus         . pkey_qwerty_bracketright)
     (lkey_comma        . pkey_qwerty_w)
     (lkey_minus        . pkey_qwerty_apostrophe)
     (lkey_period       . pkey_qwerty_e)
     (lkey_slash        . pkey_qwerty_bracketleft)
     ;(lkey_0            . pkey_qwerty_0)
     ;(lkey_1            . pkey_qwerty_1)
     ;(lkey_2            . pkey_qwerty_2)
     ;(lkey_3            . pkey_qwerty_3)
     ;(lkey_4            . pkey_qwerty_4)
     ;(lkey_5            . pkey_qwerty_5)
     ;(lkey_6            . pkey_qwerty_6)
     ;(lkey_7            . pkey_qwerty_7)
     ;(lkey_8            . pkey_qwerty_8)
     ;(lkey_9            . pkey_qwerty_9)
     (lkey_colon        . pkey_qwerty_z)
     (lkey_semicolon    . pkey_qwerty_z)
     (lkey_less         . pkey_qwerty_w)
     (lkey_equal        . pkey_qwerty_bracketright)
     (lkey_greater      . pkey_qwerty_e)
     (lkey_question     . pkey_qwerty_bracketleft)
     ;(lkey_at           . pkey_qwerty_2)
     (lkey_A            . pkey_qwerty_a)
     (lkey_B            . pkey_qwerty_n)
     (lkey_C            . pkey_qwerty_i)
     (lkey_D            . pkey_qwerty_h)
     (lkey_E            . pkey_qwerty_d)
     (lkey_F            . pkey_qwerty_y)
     (lkey_G            . pkey_qwerty_u)
     (lkey_H            . pkey_qwerty_j)
     (lkey_I            . pkey_qwerty_g)
     (lkey_J            . pkey_qwerty_c)
     (lkey_K            . pkey_qwerty_v)
     (lkey_L            . pkey_qwerty_p)
     (lkey_M            . pkey_qwerty_m)
     (lkey_N            . pkey_qwerty_l)
     (lkey_O            . pkey_qwerty_s)
     (lkey_P            . pkey_qwerty_r)
     (lkey_Q            . pkey_qwerty_x)
     (lkey_R            . pkey_qwerty_o)
     (lkey_S            . pkey_qwerty_semicolon)
     (lkey_T            . pkey_qwerty_k)
     (lkey_U            . pkey_qwerty_f)
     (lkey_V            . pkey_qwerty_period)
     (lkey_W            . pkey_qwerty_comma)
     (lkey_X            . pkey_qwerty_b)
     (lkey_Y            . pkey_qwerty_t)
     (lkey_Z            . pkey_qwerty_slash)
     (lkey_bracketleft  . pkey_qwerty_minus)
     ;;(lkey_backslash    . pkey_qwerty_backslash)
     (lkey_bracketright . pkey_qwerty_equal)
     ;;(lkey_asciicircum  . pkey_qwerty_6)
     (lkey_underscore   . pkey_qwerty_apostrophe)
     ;;(lkey_grave        . pkey_qwerty_grave)
     (lkey_a            . pkey_qwerty_a)    
     (lkey_b            . pkey_qwerty_n)    
     (lkey_c            . pkey_qwerty_i)    
     (lkey_d            . pkey_qwerty_h)    
     (lkey_e            . pkey_qwerty_d)    
     (lkey_f            . pkey_qwerty_y)    
     (lkey_g            . pkey_qwerty_u)    
     (lkey_h            . pkey_qwerty_j)    
     (lkey_i            . pkey_qwerty_g)    
     (lkey_j            . pkey_qwerty_c)    
     (lkey_k            . pkey_qwerty_v)    
     (lkey_l            . pkey_qwerty_p)    
     (lkey_m            . pkey_qwerty_m)    
     (lkey_n            . pkey_qwerty_l)    
     (lkey_o            . pkey_qwerty_s)    
     (lkey_p            . pkey_qwerty_r)    
     (lkey_q            . pkey_qwerty_x)    
     (lkey_r            . pkey_qwerty_o)    
     (lkey_s            . pkey_qwerty_semicolon)
     (lkey_t            . pkey_qwerty_k)    
     (lkey_u            . pkey_qwerty_f)    
     (lkey_v            . pkey_qwerty_period)
     (lkey_w            . pkey_qwerty_comma)
     (lkey_x            . pkey_qwerty_b)    
     (lkey_y            . pkey_qwerty_t)    
     (lkey_z            . pkey_qwerty_slash)
     (lkey_braceleft    . pkey_qwerty_minus)
     ;;(lkey_bar          . pkey_qwerty_backslash)
     (lkey_braceright   . pkey_qwerty_equal)
     ;;(lkey_asciitilde   . pkey_qwerty_grave)
     )
   lkey-qwerty->pkey-qwerty-alist
   ))

;; TODO: make pkey_jp106_a macheable with pkey_qwerty_a
(define lkey-jp106-qwerty->pkey-jp106-alist
  '(
    (lkey_BackSpace   . pkey_jp106_BackSpace)
    (lkey_Tab         . pkey_jp106_Tab)
    (lkey_Return      . pkey_jp106_Return)
    (lkey_Escape      . pkey_jp106_Escape)
    (lkey_Delete      . pkey_jp106_Delete)
    (lkey_Home        . pkey_jp106_Home)
    (lkey_Left        . pkey_jp106_Left)
    (lkey_Up          . pkey_jp106_Up)
    (lkey_Right       . pkey_jp106_Right)
    (lkey_Down        . pkey_jp106_Down)
    (lkey_Page_Up     . pkey_jp106_Page_Up)
    (lkey_Page_Down   . pkey_jp106_Page_Down)
    (lkey_End         . pkey_jp106_End)
    (lkey_Insert      . pkey_jp106_Insert)
			   
    (lkey_Shift_L     . pkey_jp106_Shift_L)
    (lkey_Shift_R     . pkey_jp106_Shift_R)
    (lkey_Control_L   . pkey_jp106_Control_L)
    (lkey_Control_R   . pkey_jp106_Control_R)
    (lkey_Caps_Lock   . pkey_jp106_Caps_Lock)
    ;;(lkey_Meta_L      . pkey_jp106_Meta_L)
    ;;(lkey_Meta_R      . pkey_jp106_Meta_R)
    (lkey_Alt_L       . pkey_jp106_Alt_L)
    (lkey_Alt_R       . pkey_jp106_Alt_R)
    ;;(lkey_Super_L     . pkey_jp106_Super_L)
    ;;(lkey_Super_R     . pkey_jp106_Super_R)
    ;;(lkey_Hyper_L     . pkey_jp106_Hyper_L)
    ;;(lkey_Hyper_R     . pkey_jp106_Hyper_R)

    ;;(lkey_Multi_key   . pkey_jp106_Multi_key)
    ;;(lkey_Mode_switch . pkey_jp106_Mode_switch)

    ;; Japanese keyboard support
    (lkey_Kanji             . pkey_jp106_Zenkaku_Hankaku)
    (lkey_Muhenkan          . pkey_jp106_Muhenkan)
    (lkey_Henkan            . pkey_jp106_Henkan)
    (lkey_Hiragana_Katakana . pkey_jp106_Hiragana_Katakana)
    (lkey_Zenkaku_Hankaku   . pkey_jp106_Zenkaku_Hankaku)

    (lkey_F1  . pkey_jp106_F1)
    (lkey_F2  . pkey_jp106_F2)
    (lkey_F3  . pkey_jp106_F3)
    (lkey_F4  . pkey_jp106_F4)
    (lkey_F5  . pkey_jp106_F5)
    (lkey_F6  . pkey_jp106_F6)
    (lkey_F7  . pkey_jp106_F7)
    (lkey_F8  . pkey_jp106_F8)
    (lkey_F9  . pkey_jp106_F9)
    (lkey_F10 . pkey_jp106_F10)
    (lkey_F11 . pkey_jp106_F11)
    (lkey_F12 . pkey_jp106_F12)
    (lkey_F13 . pkey_jp106_F13)
    (lkey_F14 . pkey_jp106_F14)
    (lkey_F15 . pkey_jp106_F15)
    (lkey_F16 . pkey_jp106_F16)
    (lkey_F17 . pkey_jp106_F17)
    (lkey_F18 . pkey_jp106_F18)
    (lkey_F19 . pkey_jp106_F19)
    (lkey_F20 . pkey_jp106_F20)
    (lkey_F21 . pkey_jp106_F21)
    (lkey_F22 . pkey_jp106_F22)
    (lkey_F23 . pkey_jp106_F23)
    (lkey_F24 . pkey_jp106_F24)
    (lkey_F25 . pkey_jp106_F25)
    (lkey_F26 . pkey_jp106_F26)
    (lkey_F27 . pkey_jp106_F27)
    (lkey_F28 . pkey_jp106_F28)
    (lkey_F29 . pkey_jp106_F29)
    (lkey_F30 . pkey_jp106_F30)
    (lkey_F31 . pkey_jp106_F31)
    (lkey_F32 . pkey_jp106_F32)
    (lkey_F33 . pkey_jp106_F33)
    (lkey_F34 . pkey_jp106_F34)
    (lkey_F35 . pkey_jp106_F35)

    ;; ASCII keys
    (lkey_space        . pkey_jp106_space)
    (lkey_exclam       . pkey_jp106_1)
    (lkey_quotedbl     . pkey_jp106_2)
    (lkey_numbersign   . pkey_jp106_3)
    (lkey_dollar       . pkey_jp106_4)
    (lkey_percent      . pkey_jp106_5)
    (lkey_ampersand    . pkey_jp106_6)
    (lkey_apostrophe   . pkey_jp106_7)
    (lkey_parenleft    . pkey_jp106_8)
    (lkey_parenright   . pkey_jp106_9)
    (lkey_asterisk     . pkey_jp106_colon)
    (lkey_plus         . pkey_jp106_semicolon)
    (lkey_comma        . pkey_jp106_comma)
    (lkey_minus        . pkey_jp106_minus)
    (lkey_period       . pkey_jp106_period)
    (lkey_slash        . pkey_jp106_slash)
    (lkey_0            . pkey_jp106_0)
    (lkey_1            . pkey_jp106_1)
    (lkey_2            . pkey_jp106_2)
    (lkey_3            . pkey_jp106_3)
    (lkey_4            . pkey_jp106_4)
    (lkey_5            . pkey_jp106_5)
    (lkey_6            . pkey_jp106_6)
    (lkey_7            . pkey_jp106_7)
    (lkey_8            . pkey_jp106_8)
    (lkey_9            . pkey_jp106_9)
    (lkey_colon        . pkey_jp106_colon)
    (lkey_semicolon    . pkey_jp106_semicolon)
    (lkey_less         . pkey_jp106_comma)
    (lkey_equal        . pkey_jp106_minus)
    (lkey_greater      . pkey_jp106_period)
    (lkey_question     . pkey_jp106_slash)
    (lkey_at           . pkey_jp106_at)
    (lkey_A            . pkey_jp106_a)
    (lkey_B            . pkey_jp106_b)
    (lkey_C            . pkey_jp106_c)
    (lkey_D            . pkey_jp106_d)
    (lkey_E            . pkey_jp106_e)
    (lkey_F            . pkey_jp106_f)
    (lkey_G            . pkey_jp106_g)
    (lkey_H            . pkey_jp106_h)
    (lkey_I            . pkey_jp106_i)
    (lkey_J            . pkey_jp106_j)
    (lkey_K            . pkey_jp106_k)
    (lkey_L            . pkey_jp106_l)
    (lkey_M            . pkey_jp106_m)
    (lkey_N            . pkey_jp106_n)
    (lkey_O            . pkey_jp106_o)
    (lkey_P            . pkey_jp106_p)
    (lkey_Q            . pkey_jp106_q)
    (lkey_R            . pkey_jp106_r)
    (lkey_S            . pkey_jp106_s)
    (lkey_T            . pkey_jp106_t)
    (lkey_U            . pkey_jp106_u)
    (lkey_V            . pkey_jp106_v)
    (lkey_W            . pkey_jp106_w)
    (lkey_X            . pkey_jp106_x)
    (lkey_Y            . pkey_jp106_y)
    (lkey_Z            . pkey_jp106_z)
    (lkey_bracketleft  . pkey_jp106_bracketleft)
    (lkey_backslash    . pkey_jp106_yen)        ;; be careful
    ;;(lkey_backslash    . pkey_jp106_backslash)  ;; be careful
    (lkey_bracketright . pkey_jp106_bracketright)
    (lkey_asciicircum  . pkey_jp106_asciicircum)
    (lkey_underscore   . pkey_jp106_backslash)  ;; be careful
    (lkey_grave        . pkey_jp106_at)
    (lkey_a            . pkey_jp106_a)
    (lkey_b            . pkey_jp106_b)
    (lkey_c            . pkey_jp106_c)
    (lkey_d            . pkey_jp106_d)
    (lkey_e            . pkey_jp106_e)
    (lkey_f            . pkey_jp106_f)
    (lkey_g            . pkey_jp106_g)
    (lkey_h            . pkey_jp106_h)
    (lkey_i            . pkey_jp106_i)
    (lkey_j            . pkey_jp106_j)
    (lkey_k            . pkey_jp106_k)
    (lkey_l            . pkey_jp106_l)
    (lkey_m            . pkey_jp106_m)
    (lkey_n            . pkey_jp106_n)
    (lkey_o            . pkey_jp106_o)
    (lkey_p            . pkey_jp106_p)
    (lkey_q            . pkey_jp106_q)
    (lkey_r            . pkey_jp106_r)
    (lkey_s            . pkey_jp106_s)
    (lkey_t            . pkey_jp106_t)
    (lkey_u            . pkey_jp106_u)
    (lkey_v            . pkey_jp106_v)
    (lkey_w            . pkey_jp106_w)
    (lkey_x            . pkey_jp106_x)
    (lkey_y            . pkey_jp106_y)
    (lkey_z            . pkey_jp106_z)
    (lkey_braceleft    . pkey_jp106_bracketleft)
    (lkey_bar          . pkey_jp106_yen)        ;; be careful
    ;;(lkey_bar          . pkey_jp106_backslash)  ;; be careful
    (lkey_braceright   . pkey_jp106_bracketright)
    (lkey_asciitilde   . pkey_jp106_asciicircum)

    ;; extended keys
    (lkey_yen                   . pkey_jp106_yen)  ;; be careful
    ;;(lkey_backslash             . pkey_jp106_yen)  ;; be careful

    ;; dead keys: JP106 keyboard does not have these keys
    ;;(lkey_dead_grave            . pkey_jp106_grave)
    ;;(lkey_dead_acute            . pkey_jp106_acute)
    ;;(lkey_dead_circumflex       . pkey_jp106_circumflex)
    ;;(lkey_dead_tilde            . pkey_jp106_tilde)
    ;;(lkey_dead_macron           . pkey_jp106_macron)
    ;;(lkey_dead_breve            . pkey_jp106_breve)
    ;;(lkey_dead_abovedot         . pkey_jp106_abovedot)
    ;;(lkey_dead_diaeresis        . pkey_jp106_diaeresis)
    ;;(lkey_dead_abovering        . pkey_jp106_abovering)
    ;;(lkey_dead_doubleacute      . pkey_jp106_doubleacute)
    ;;(lkey_dead_caron            . pkey_jp106_caron)
    ;;(lkey_dead_cedilla          . pkey_jp106_cedilla)
    ;;(lkey_dead_ogonek           . pkey_jp106_ogonek)
    ;;(lkey_dead_iota             . pkey_jp106_iota)
    ;;(lkey_dead_voiced_sound     . pkey_jp106_voiced_sound)
    ;;(lkey_dead_semivoiced_sound . pkey_jp106_semivoiced_sound)
    ;;(lkey_dead_belowdot         . pkey_jp106_belowdot)
    ;;(lkey_dead_hook             . pkey_jp106_hook)
    ;;(lkey_dead_horn             . pkey_jp106_horn)
    ))

(define lkey-jp106-dvorak->pkey-jp106-alist
  (append
   '(;; ASCII keys
     ;(lkey_space        . pkey_jp106_space)
     ;(lkey_exclam       . pkey_jp106_1)
     (lkey_quotedbl     . pkey_jp106_q)
     ;(lkey_numbersign   . pkey_jp106_3)
     ;(lkey_dollar       . pkey_jp106_4)
     ;(lkey_percent      . pkey_jp106_5)
     ;(lkey_ampersand    . pkey_jp106_7)
     (lkey_apostrophe   . pkey_jp106_q)
     ;(lkey_parenleft    . pkey_jp106_9)
     ;(lkey_parenright   . pkey_jp106_0)
     ;(lkey_asterisk     . pkey_jp106_8)
     (lkey_plus         . pkey_jp106_bracketright)
     (lkey_comma        . pkey_jp106_w)
     (lkey_minus        . pkey_jp106_apostrophe)
     (lkey_period       . pkey_jp106_e)
     (lkey_slash        . pkey_jp106_bracketleft)
     ;(lkey_0            . pkey_jp106_0)
     ;(lkey_1            . pkey_jp106_1)
     ;(lkey_2            . pkey_jp106_2)
     ;(lkey_3            . pkey_jp106_3)
     ;(lkey_4            . pkey_jp106_4)
     ;(lkey_5            . pkey_jp106_5)
     ;(lkey_6            . pkey_jp106_6)
     ;(lkey_7            . pkey_jp106_7)
     ;(lkey_8            . pkey_jp106_8)
     ;(lkey_9            . pkey_jp106_9)
     (lkey_colon        . pkey_jp106_z)
     (lkey_semicolon    . pkey_jp106_z)
     (lkey_less         . pkey_jp106_w)
     (lkey_equal        . pkey_jp106_bracketright)
     (lkey_greater      . pkey_jp106_e)
     (lkey_question     . pkey_jp106_bracketleft)
     ;(lkey_at           . pkey_jp106_2)
     (lkey_A            . pkey_jp106_a)
     (lkey_B            . pkey_jp106_n)
     (lkey_C            . pkey_jp106_i)
     (lkey_D            . pkey_jp106_h)
     (lkey_E            . pkey_jp106_d)
     (lkey_F            . pkey_jp106_y)
     (lkey_G            . pkey_jp106_u)
     (lkey_H            . pkey_jp106_j)
     (lkey_I            . pkey_jp106_g)
     (lkey_J            . pkey_jp106_c)
     (lkey_K            . pkey_jp106_v)
     (lkey_L            . pkey_jp106_p)
     (lkey_M            . pkey_jp106_m)
     (lkey_N            . pkey_jp106_l)
     (lkey_O            . pkey_jp106_s)
     (lkey_P            . pkey_jp106_r)
     (lkey_Q            . pkey_jp106_x)
     (lkey_R            . pkey_jp106_o)
     (lkey_S            . pkey_jp106_semicolon)
     (lkey_T            . pkey_jp106_k)
     (lkey_U            . pkey_jp106_f)
     (lkey_V            . pkey_jp106_period)
     (lkey_W            . pkey_jp106_comma)
     (lkey_X            . pkey_jp106_b)
     (lkey_Y            . pkey_jp106_t)
     (lkey_Z            . pkey_jp106_slash)
     (lkey_bracketleft  . pkey_jp106_minus)
     ;;(lkey_backslash    . pkey_jp106_backslash)
     (lkey_bracketright . pkey_jp106_asciicircum)
     ;;(lkey_asciicircum  . pkey_jp106_6)
     (lkey_underscore   . pkey_jp106_colon)
     ;;(lkey_grave        . pkey_jp106_grave)
     (lkey_a            . pkey_jp106_a)    
     (lkey_b            . pkey_jp106_n)    
     (lkey_c            . pkey_jp106_i)    
     (lkey_d            . pkey_jp106_h)    
     (lkey_e            . pkey_jp106_d)    
     (lkey_f            . pkey_jp106_y)    
     (lkey_g            . pkey_jp106_u)    
     (lkey_h            . pkey_jp106_j)    
     (lkey_i            . pkey_jp106_g)    
     (lkey_j            . pkey_jp106_c)    
     (lkey_k            . pkey_jp106_v)    
     (lkey_l            . pkey_jp106_p)    
     (lkey_m            . pkey_jp106_m)    
     (lkey_n            . pkey_jp106_l)    
     (lkey_o            . pkey_jp106_s)    
     (lkey_p            . pkey_jp106_r)    
     (lkey_q            . pkey_jp106_x)    
     (lkey_r            . pkey_jp106_o)    
     (lkey_s            . pkey_jp106_semicolon)
     (lkey_t            . pkey_jp106_k)    
     (lkey_u            . pkey_jp106_f)    
     (lkey_v            . pkey_jp106_period)
     (lkey_w            . pkey_jp106_comma)
     (lkey_x            . pkey_jp106_b)    
     (lkey_y            . pkey_jp106_t)    
     (lkey_z            . pkey_jp106_slash)
     (lkey_braceleft    . pkey_jp106_minus)
     ;;(lkey_bar          . pkey_jp106_backslash)
     (lkey_braceright   . pkey_jp106_asciicircum)
     ;;(lkey_asciitilde   . pkey_jp106_grave)
     )
   lkey-jp106-qwerty->pkey-jp106-alist
   ))


;; register physical key symbols to valid-physical-keys
(for-each (lambda (alist)
	    (for-each (lambda (entry)
			(let ((pkey (cdr entry)))
			  (or (memq pkey valid-physical-keys)
			      (set! valid-physical-keys
				    (cons pkey valid-physical-keys)))))
		      alist))
	  (list lkey-qwerty->pkey-qwerty-alist
		lkey-extended-qwerty->pkey-qwerty-alist
		lkey-jp106-qwerty->pkey-jp106-alist))

;; FIXME: bad procedure name
(define lkey->pkey-alist
  (lambda ()
    (let ((alist-sym (symbolconc 'lkey-
				 system-logical-key-mapping
				 '->pkey-
				 system-physical-keyboard-type
				 '-alist)))
      (or (and (symbol-bound? alist-sym)
	       (symbol-value alist-sym))
	  ()))))

(define lkey->pkey
  (lambda (lkey)
    (let ((alist (lkey->pkey-alist)))
      (assq-cdr lkey alist))))