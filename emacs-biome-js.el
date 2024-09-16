;;; emacs-biome-js.el --- Integration between the BiomeJS linter/formatter and Emacs  -*- lexical-binding:t -*-

;; Copyright (C) 2024 SPM

;; Author: freesteph
;; Version: 0.1
;; Keywords: text, tools
;; Package-Requires: ((flycheck))
;; URL: https://github.com/freesteph/emacs-biome-js

;;; Commentary:

;; This package provides a Flycheck backend and a minor-mode to
;; format-on-save files using BiomeJS.
;;
;; (add-to-list 'flycheck-checkers 'biome)

(require 'flycheck)

;;; Code:
(flycheck-define-checker biome
  "A Javascript compiler using the Biome linter/formatter."
  :command ("biome" "check" "--reporter" "github" source)
  :error-patterns
  ((error line-start
          "::error title=" (+? anychar)
          ",file=" (file-name)
          ",line=" line
          ",endLine=" end-line
          ",col=" column
          ",endColumn=" end-column
          "::" (message)
          line-end))
  :modes js-mode)

(defun biomejs--format-and-write-buffer ()
  "Formats the `current-buffer' using Biome."
  (call-process
   "biome"
   nil
   "*Flycheck/Biome autosave process*"
   t
   "check"
   "--write"
   (buffer-file-name)))

;;;###autoload
(define-minor-mode biome-js-autosave-mode
  "Makes BiomeJS autoformat the current file on save."
  (add-hook 'after-save-hook 'biomejs--format-and-write-buffer))

(provide 'emacs-biome-js)

;;; emacs-biome-js.el ends here
