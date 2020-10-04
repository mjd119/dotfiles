;;; autoload.el -*- lexical-binding: t; -*-

; Truncate the buffer name on the mode-line (mjd119) from https://www.reddit.com/r/DoomEmacs/comments/ie96qy/truncating_buffer_name_on_mode_line_doommodeline/
;;;###autoload
(defvar durand-buffer-name-max 100
  "The maximal length of the buffer name in modeline.")

;;;###autoload
(defun doom-modeline-segment--buffer-info-durand ()
  "Almost the same as `doom-modeline-segment--buffer-info',
but it truncates the buffer name within `durand-buffer-name-max'."
  (concat
   (s-truncate durand-buffer-name-max
               (format-mode-line (doom-modeline-segment--buffer-info))
               "...")))

(byte-compile 'doom-modeline-segment--buffer-info-durand)
