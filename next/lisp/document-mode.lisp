;;;; document-mode.lisp --- document major mode for internet documents

(in-package :next)

(defvar document-mode-hook nil)
(defvar document-mode-map (make-hash-table :test 'equalp))

(defclass document-mode (mode) ())

(defun scroll-down ()
  (|scroll| (|mainFrame| (|page| (buffer-view *active-buffer*))) 0 30))

(defun scroll-up ()
  (|scroll| (|mainFrame| (|page| (buffer-view *active-buffer*))) 0 -30))

(defun set-url-new-buffer (input-url)
  (let ((new-buffer (generate-new-buffer "default" (document-mode))))
    (set-visible-active-buffer new-buffer)
    (set-url input-url)))

(defun set-url-buffer (input-url buffer)
  (setf (buffer-name buffer) input-url)
  (qlet ((url (qnew "QUrl(QString)" input-url)))
	(|setUrl| (buffer-view buffer) url)))

(defun set-url (input-url)
  (set-url-buffer input-url *active-buffer*))

(defun document-mode ()
  "Base mode for interacting with documents"
  (make-instance 'document-mode
   :name "Document-Mode"
   :keymap document-mode-map
   :view (qnew "QWebView")))

(define-key document-mode-map (kbd "C-p") #'scroll-up)
(define-key document-mode-map (kbd "C-n") #'scroll-down)
(define-key document-mode-map (kbd "C-l") (:input set-url))
(define-key document-mode-map (kbd "S-l") (:input set-url-new-buffer))
