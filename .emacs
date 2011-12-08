; This is a SAMPLE .emacs file
;; Feel free to use this as a base for customizing emacs

;; This is the directory that the master.emacs file resides in
(defvar master-dir (getenv "ADMIN_SCRIPTS"))
(load-library (concat master-dir "/master.emacs"))

;; Load up the search tags file
(setq large-file-warning-threshold nil)
(visit-tags-table "~/www/TAGS")

;; Have highlighting all the time
(global-font-lock-mode 1)

;; no need for the menu bar since we are in terminal mode most of the time
(menu-bar-mode 0)

(setq-default indent-tabs-mode nil)

;; Switch to visible bell instead of audio bell
(setq-default visible-bell t)
(setq-default bell-inhibit-time 10)

;; uncomment to see trailing whitespace
;; (setq-default show-trailing-whitespace t)

(custom-set-variables '(load-home-init-file t t))
;; (custom-set-faces)

;; automatic highlighting of opening/closing paren
(show-paren-mode t)
(setq show-paren-style 'mixed)

(tool-bar-mode)
(setq-default case-fold-search t)

;; Global key bindings
(global-set-key "\M-g"  'goto-line)
;; (global-set-key "\C-q"  'undo)
(global-set-key "\C-c"  'copy-region-as-kill)
(global-set-key "\C-p"  'backward-word)

;; Set ctrl-arrow keys to move words/pages
(global-set-key "\M-[C" 'forward-word)
(global-set-key "\M-[D" 'backward-word)
(global-set-key "\M-[B" 'scroll-up)
(global-set-key "\M-[A" 'scroll-down)

(global-set-key "\M-[5C" 'forward-word)
(global-set-key "\M-[5D" 'backward-word)
;; Enable highlighting of selected regions
;; Remove those annoying .~ files
(setq backup-directory-alist (quote ((".*" . "~/.old"))))

;; Enable highlighting of selected regions
(transient-mark-mode 1)

;; Function definitions
(defun indent-all ()
    "Indent entire buffer."
    (interactive)
    (indent-region (point-min) (point-max) nil))

;; Python Mode for .pillar file
(setq auto-mode-alist (append '(("\\.pillar$" . python-mode))
                              auto-mode-alist))

;; Lisp mode for anything that ends in .emacs
(setq auto-mode-alist (append '(("\\.emacs$" . lisp-mode))
                              auto-mode-alist))


;; set up css mode
(autoload 'css-mode "css-mode" "Major mode for editing css" t)
(setq auto-mode-alist
      (cons '("\\.css\\'" . css-mode) auto-mode-alist))


;; Colorings
(set-foreground-color "#dbdbdb")
(set-background-color "#000000")
(custom-set-faces
 '(font-lock-comment-face ((t (:foreground "cyan"))))
)

;; Make M-x grep actually run tbgr, then C-x ` goes to
;; the next result, mouse clicks work, etc.
;; (later we could define interactive commands tbgr, tbgs, etc.)
(custom-set-variables
 '(grep-command "tbgr "))

;; Hari's .emacs stuff

(add-to-list 'load-path "~/.emacs.d/")
(add-to-list 'load-path "~/.emacs.d/auto-install/")

;; load auto-install and specify the directory
(require 'auto-install)
(setq auto-install-directory "~/.emacs.d/auto-install/")
(auto-install-update-emacswiki-package-name t)

(setq make-backup-files nil)
(delete-selection-mode t)

(setq tramp-default-method "ssh")
(require 'tramp)

(defun reload-dot-emacs ()
  "Save the .emacs buffer if needed, then reload .emacs."
  (interactive)
  (let ((dot-emacs "~/.emacs"))
    (and (get-file-buffer dot-emacs)
         (save-buffer (get-file-buffer dot-emacs)))
    (load-file dot-emacs))
  (message "Re-initialized!"))

(require 'linum)
(global-linum-mode 1)

(column-number-mode t)

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

;; (setq x-select-enable-clipboard t) ;; to be able to copy into the system clipboard
;; (setq interprogram-paste-function 'x-cut-buffer-or-selection-value)

(require 'xclip)
(turn-on-xclip)

(global-set-key (kbd "M-`") 'other-window)
(global-set-key (kbd "C-f") 'find-file-at-point)
(global-set-key (kbd "C-x /") 'comment-or-uncomment-region)

;; will scroll one line at a time instead of jumping on cursor up/down
(require 'smooth-scrolling)

;; auto-complete on steroids
(require 'pabbrev)

(defun revert-all-buffers ()
  (interactive)
  (let ((current-buffer (buffer-name)))
    (loop for buf in (buffer-list)
          do
          (unless (null (buffer-file-name buf))
            (switch-to-buffer (buffer-name buf))
            (revert-buffer nil t)))
    (switch-to-buffer current-buffer)
    (message "All buffers reverted!")))


;; Split into as many vertical windows as possible
(defun smart-split ()
  "Split the frame into exactly as many 80-column sub-windows as
   possible."
  (interactive)
  (defun ordered-window-list ()
    "Get the list of windows in the selected frame, starting from
     the one at the top left."
    (window-list (selected-frame) (quote no-minibuf) (frame-first-window)))
  (defun resize-windows-destructively (windows)
    "Resize each window in the list to be 80 characters wide. If
     there is not enough space to do that, delete the appropriate
     window until there is space."
    (when windows
      (condition-case nil
          (progn
            (adjust-window-trailing-edge
             (first windows)
             (- 80 (window-width (first windows))) t)
            (resize-windows-destructively (cdr windows)))
        (error
         (if (cdr windows)
             (progn
               (delete-window (cadr windows))
               (resize-windows-destructively
                (cons (car windows) (cddr windows))))
           (ignore-errors
             (delete-window (car windows))))))))
  (defun subsplit (w)
    "If the given window can be split into multiple 80-column
     windows, do it."
    (when (> (window-width w) (* 2 81))
      (let ((w2 (split-window w 82 t)))
        (save-excursion
          (select-window w2)
          (switch-to-buffer (other-buffer (window-buffer w)))))
      (subsplit w)))
  (resize-windows-destructively (ordered-window-list))
  (walk-windows (quote subsplit))
  (balance-windows))

(setq magic-mode-alist (append '(("<\\?php\\s " . xhp-mode)) magic-mode-alist))
(setq auto-mode-alist (append '(("\\.php$" . xhp-mode)) auto-mode-alist))

(require 'goto-last-change)
(global-set-key "\C-q" 'goto-last-change)

;; (require 'redo)
(require 'undo-tree)
(global-undo-tree-mode)
