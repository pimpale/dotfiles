(defvar --backup-directory "~/.emacsbackups")
(if (not (file-exists-p --backup-directory))
    (make-directory --backup-directory t))
(setq make-backup-directory-alist `(("." . ,--backup-directory)))
(setq make-backup-files t
      backup-by-copying t
      version-control t
      delete-old-versions t
      auto-save-default t)

(setq vc-follow-symlinks nil)

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages"))
