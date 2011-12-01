(add-to-list 'load-path "~/.emacs.d/")
(add-to-list 'load-path "~/.emacs.d/auto-install/")

;; load auto-install and specify the directory
(require 'auto-install)
(setq auto-install-directory "~/.emacs.d/auto-install/")
(auto-install-update-emacswiki-package-name t)

(tool-bar-mode 0)
(setq ring-bell-function 'ignore)
(setq frame-title-format "%b")
(setq make-backup-files nil)
(delete-selection-mode t)

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(indent-tabs-mode nil)
 '(c-basic-offset 2)
 '(inhibit-startup-screen t))

(toggle-scroll-bar -1)

(setq tramp-default-method "ssh")
(require 'tramp)
(require 'redo)       ; enables C-r (redo key)
(define-key global-map (kbd "C-?") 'redo)
(define-key global-map (kbd "C-/") 'undo)

(defun reload-dot-emacs ()
  "Save the .emacs buffer if needed, then reload .emacs."
  (interactive)
  (let ((dot-emacs "~/.emacs"))
    (and (get-file-buffer dot-emacs)
         (save-buffer (get-file-buffer dot-emacs)))
    (load-file dot-emacs))
  (message "Re-initialized!"))

(require 'color-theme)
(color-theme-initialize)
(color-theme-midnight)

(if (window-system) (set-frame-size (selected-frame) 131 90))
(require 'linum)
(global-linum-mode 1)

(column-number-mode t)

(define-key global-map (kbd "<C-tab>") 'other-window)
(require 'ido)
(iswitchb-mode 1)
(defun iswitchb-local-keys ()
      (mapc (lambda (K)
	      (let* ((key (car K)) (fun (cdr K)))
    	        (define-key iswitchb-mode-map (edmacro-parse-keys key) fun)))
	    '(("<right>" . iswitchb-next-match)
	      ("<left>"  . iswitchb-prev-match)
	      ("<up>"    . ignore             )
	      ("<down>"  . ignore             ))))
(add-hook 'iswitchb-define-mode-map-hook 'iswitchb-local-keys)

(defalias 'couc 'comment-or-uncomment-region)
(global-set-key (kbd "C-#") 'couc)

 (defun revert-all-buffers()
      "Refreshs all open buffers from their respective files"
      (interactive)
      (let* ((list (buffer-list))
	      (buffer (car list)))
        (while buffer
          (if (string-match "\\*" (buffer-name buffer))
	      (progn
	        (setq list (cdr list))
	        (setq buffer (car list)))
	      (progn
	        (set-buffer buffer)
	        (revert-buffer t t t)
	        (setq list (cdr list))
	        (setq buffer (car list))))))
      (message "Refreshing open files"))

;;; Electric Pairs
(defun electric-pair ()
      "If at end of line, insert character pair without surrounding spaces.
    Otherwise, just insert the typed character."
      (interactive)
      (if (eolp) (let (parens-require-spaces) (insert-pair)) (self-insert-command 1)))

(add-hook 'python-mode-hook
              (lambda ()
                (define-key python-mode-map "\"" 'electric-pair)
                (define-key python-mode-map "\'" 'electric-pair)
                (define-key python-mode-map "(" 'electric-pair)
                (define-key python-mode-map "[" 'electric-pair)
                (define-key python-mode-map "{" 'electric-pair)))

;;; bind RET to py-newline-and-indent
(add-hook 'python-mode-hook '(lambda ()
     (define-key python-mode-map "\C-m" 'newline-and-indent)))


;; ;;; set tabs to 4 spaces
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq-default py-indent-offset 4)
(add-to-list 'load-path "which-folder-ace-jump-mode-file-in/")
(require 'ace-jump-mode)
(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)

(require 'pig-mode)

(require 'php-mode)


