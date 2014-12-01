;;;
;;; �齬�ǻȤ���ư��֥�ǥ�
;;;   2009/11/14 written by nakanish
;;;
(load "irteusext.l")

#|********************************
         link����� (��������)
  ********************************|#
;;    ����parts 
;; 1. �Ҥ�
(defun make-hinji nil
  (let* ((hinji-width 50)   ;;��
	 (hinji-height 26)  ;;�⤵
	 (hinji-depth 15)   ;;���Ԥ�
	 (thickness 4)      ;;����
	 (b                 ;;����
	  (make-cube hinji-depth hinji-width hinji-height))  
	 (b1                ;;ȴ��Τ����cube
	  (make-cube (*  hinji-depth 2)                 ;;���Ԥ���original�����礭��
		     (- hinji-width (* 2 thickness))    ;;���ϸ�����ʬ������
		     hinji-height))                     ;;�⤵��Ʊ���Ǥ���
	 (color :grey80)
	 )
    (send b1 :translate (float-vector 0 0 (* -1 thickness)))
    (setq b (body- b b1))
    ;;hinji�δ����濴�����˰�ư
    (send b :translate-vertices (float-vector 0 0 (* 0.5 hinji-height)))
    ;;�������
    (setf (get b :face-color) color)
    ;;����򥻥åȤ��Ƥ���
    (setf (get b :hinji-width) hinji-width)
    (setf (get b :hinji-height) hinji-height)
    (setf (get b :hinji-depth) hinji-depth)
    (send b :worldcoords)
    b))
;;
;; 2. ������(������cube)
(defun make-servo nil
  (let* ((servo-width 35)
	 (servo-height 46)
	 (servo-depth 20)
	 (joint-height 10)  ;;servo��joint��depth�����ο��桢�⤵������joint-height�ˤ�������
	 (joint-width (+ servo-width (* 7 2)))
	 (b
	  (make-cube servo-depth servo-width servo-height))
	 (c (make-cylinder 5 joint-width)) ;;joint��
	 (color :grey20)
	 )
    (send b :translate-vertices (float-vector 0 0 (- (* 0.5 servo-height) joint-height)))
    (send c :translate-vertices (float-vector 0 0 (* -0.5 joint-width)))
    (send c :rotate-vertices pi/2 :x)  ;;x�����ˣ����ٲ�ž
    (setq b (body+ b c))
    (setf (get b :face-color) color)
    ;;����򥻥åȤ��Ƥ���
    (setf (get b :servo-width) servo-width)
    (setf (get b :servo-height) servo-height)
    (setf (get b :servo-depth) servo-depth)
    (setf (get b :joint-height) joint-height)
    (setf (get b :joint-width) (+ servo-width (* 7 2)))
    (send b :worldcoords)
    b))
;;
;; 3. ����ä�
(defun make-gripper nil
  (let* ((gripper-length 68)
	 (gripper-width 22)
	 (gripper-depth 46)
         (-gripper-depth/2 (/ gripper-depth -2.0))
         (gripper-width/2 (/ gripper-width 2.0))
	 (b
	  (make-prism
	   (list 
	    (float-vector 0 (* 0.5 gripper-width) -gripper-depth/2)
	    (float-vector (* 0.4 gripper-length) (* 0.5 gripper-width) -gripper-depth/2)
	    (float-vector gripper-length (* -0.3 gripper-width) -gripper-depth/2)
	    (float-vector gripper-length (* -0.5 gripper-width) -gripper-depth/2)
	    (float-vector 0 (* -0.5 gripper-width) -gripper-depth/2))
	   gripper-depth))
	 (color :grey80)
	 )
    (setf (get b :face-color) color)
    (setf (get b :length) gripper-length)
    (setf (get b :width) gripper-width)
    (setf (get b :depth) gripper-depth)
    (send b :worldcoords)
    b))
;;
;; 4. bumper
(defun make-bumper-1 nil
  (let* ((bumper-length 145)
	 (bumper-thickness 5)
	 (bumper-height 20)
	 (b
	  (make-prism
	   (list
	    (float-vector (* (cos (deg2rad -30)) bumper-length) (* (sin (deg2rad -30)) bumper-length) (* -0.5 bumper-height))
	    (float-vector (* (cos (deg2rad -60)) (* (cos (deg2rad 30)) bumper-length))
			  (* (sin (deg2rad -60)) (* (cos (deg2rad 30)) bumper-length)) (* -0.5 bumper-height))
	    (float-vector (* (cos (deg2rad -60)) (* (cos (deg2rad 30)) (- bumper-length bumper-thickness)))
			  (* (sin (deg2rad -60)) (* (cos (deg2rad 30)) (- bumper-length bumper-thickness)))
			  (* -0.5 bumper-height))
	    (float-vector (* (cos (deg2rad -30)) (- bumper-length bumper-thickness))
			  (* (sin (deg2rad -30)) (- bumper-length bumper-thickness))
			  (* -0.5 bumper-height))
	    (float-vector (* (cos (deg2rad 30)) (- bumper-length bumper-thickness))
                          (* -0.5 bumper-thickness)
                          (* -0.5 bumper-height))
	    (float-vector (* (cos (deg2rad 30)) bumper-length)
                          (* -0.5 bumper-thickness)
                          (* -0.5 bumper-height))
	    )
	   bumper-height))
	 (color :grey80)
	 )
    (setf (get b :face-color) color)
    (send b :worldcoords)
    (setq b (instance bumper-model :init b))
    b))

(defun make-bumper-2 nil
  (let* ((bumper-length 145)
	 (bumper-thickness 5)
	 (bumper-height 20)
	 (b
	  (make-prism
	   (list
	    (float-vector (* (cos (deg2rad -30)) bumper-length)
                          (* 0.5 bumper-thickness)
                          (* -0.5 bumper-height))
	    (float-vector (* (cos (deg2rad -30)) (- bumper-length bumper-thickness))
                          (* 0.5 bumper-thickness)
                          (* -0.5 bumper-height))
	    (float-vector (* (cos (deg2rad 30)) (- bumper-length bumper-thickness))
			  (* (sin (deg2rad 30)) (- bumper-length bumper-thickness))
			  (* -0.5 bumper-height))
	    (float-vector (* (cos (deg2rad 60)) (* (cos (deg2rad 30)) (- bumper-length bumper-thickness)))
			  (* (sin (deg2rad 60)) (* (cos (deg2rad 30)) (- bumper-length bumper-thickness)))
			  (* -0.5 bumper-height))
	    (float-vector (* (cos (deg2rad 60)) (* (cos (deg2rad 30)) bumper-length))
			  (* (sin (deg2rad 60)) (* (cos (deg2rad 30)) bumper-length))
                          (* -0.5 bumper-height))
	    (float-vector (* (cos (deg2rad 30)) bumper-length)
                          (* (sin (deg2rad 30)) bumper-length)
                          (* -0.5 bumper-height))
	    )
	   bumper-height))
	 (color :grey80)
	 )
    (setf (get b :face-color) color)
    (send b :worldcoords)
    (setq b (instance bumper-model :init b))
    b))

;; 5. psd
(defun make-psd nil
  (let* ((psd-depth  10)
	 (psd-width  45)
	 (psd-height 20)
         (b (make-cube psd-depth psd-width psd-height))
	 (color :grey20)
	 )
    (send b :rotate pi/2 :y)
    (setf (get b :face-color) color)
    (send b :worldcoords)
    (setq b (instance psd-model :init b))
    b))

;; 6. camera
(defun make-camera nil
  (let (c b
          (vd 1.0) (pwidth 320) (pheight 240)
          (f 100) cx cy)
    (setq cx (/ pwidth 2) cy (/ pheight 2))
    (setq b (body+ (make-cube 60 25 25) (make-cylinder 13 30)))
    (send b :set-color :white)
    (setq c (instance camera-model :init b :yon 2000.0 :hither 50 :viewdistance vd))
    (send (c . vwing) :screen (/ (* vd pwidth 0.5) f) (/ (* vd pheight 0.5) f))
    (send c :newprojection
          (make-matrix 4 4
                       (list (float-vector  f  0 cx  0)
                             (float-vector  0  f cy  0)
                             (float-vector  0  0  1  0)
                             (float-vector  0  0  0  1))))
    c))

;; ����parts (�����ޤ�)
;;
;; ���ܥåȤΤ�󤯤��äƤ���
;; 1.��� (base-body, servo, sensor-bar����ʤ�)
(defun make-daisya-base nil
  (let* (daisya-base
	 (base-body-length 120)
	 (base-body-height 60)
	 (base-body  ;;���ܤϰ���base-body-length��6�ѷ�
	  (make-prism
	   (list 
	    (float-vector (* (cos (deg2rad 330)) base-body-length) (* (sin (deg2rad 330)) base-body-length) 0)
	    (float-vector (* (cos (deg2rad 270)) base-body-length) (* (sin (deg2rad 270)) base-body-length) 0)
	    (float-vector (* (cos (deg2rad 210)) base-body-length) (* (sin (deg2rad 210)) base-body-length) 0)
	    (float-vector (* (cos (deg2rad 150)) base-body-length) (* (sin (deg2rad 150)) base-body-length) 0)
	    (float-vector (* (cos (deg2rad 90)) base-body-length) (* (sin (deg2rad 90)) base-body-length) 0)
	    (float-vector (* (cos (deg2rad 30)) base-body-length) (* (sin (deg2rad 30)) base-body-length) 0)
	    )
	   base-body-height))
	 (servo (make-servo))
	 (color :grey80)
	 (base-arm-pos 
	  (float-vector (+ (* (cos (deg2rad 30)) base-body-length) 20)
			0 
			(+ base-body-height (* 0.5 (get servo :servo-width)))))
	 (bumper1 (make-bumper-1)) (bumper2 (make-bumper-2))
         (bumper3 (make-bumper-1)) (bumper4 (make-bumper-2))
         (bumper5 (make-bumper-1)) (bumper6 (make-bumper-2))
         (psd1 (make-psd)) (psd2 (make-psd)) (psd3 (make-psd))
	 (board1 (make-cube 100 140 5)) (board2 (make-cube 100 140 5)) (board3 (make-cube 100 90 5)) (board4 (make-cube 100 90 5))
         (spacer1 (make-cylinder 3 135)) (spacer2 (make-cylinder 3 135))
         (spacer3 (make-cylinder 3 135)) (spacer4 (make-cylinder 3 135))
         (spacer5 (make-cylinder 3  50)) (spacer6 (make-cylinder 3  50))
         (camera (make-camera))
	 (parts (list servo bumper1 bumper2 bumper3 bumper4 bumper5 bumper6 psd1 psd2 psd3 board1 board2 board3 board4 spacer1 spacer2 spacer3 spacer4 spacer5 spacer6 camera))
	 )
    ;;servo���ž
    (send servo :rotate-vertices pi/2 :x)
    (send servo :rotate-vertices (* -1 pi/2) :z)
    (send servo :translate-vertices base-arm-pos)
    (setf (get base-body :base-arm-pos) (v- base-arm-pos #f(0 0 10)))
    ;;bumper������
    (send bumper1 :rotate (deg2rad 60) :z)
    (send bumper1 :translate (float-vector 10 0 (* 0.5 base-body-height)))
    (send bumper2 :rotate (deg2rad 60) :z)
    (send bumper2 :translate (float-vector 10 0 (* 0.5 base-body-height)))
    ;;
    (send bumper3 :rotate (deg2rad 180) :z)
    (send bumper3 :translate (float-vector 10 0 (* 0.5 base-body-height)))
    (send bumper4 :rotate (deg2rad 180) :z)
    (send bumper4 :translate (float-vector 10 0 (* 0.5 base-body-height)))
    ;;
    (send bumper5 :rotate (deg2rad 300) :z)
    (send bumper5 :translate (float-vector 10 0 (* 0.5 base-body-height)))
    (send bumper6 :rotate (deg2rad 300) :z)
    (send bumper6 :translate (float-vector 10 0 (* 0.5 base-body-height)))
    ;;
    ;;board������
    (send board1 :locate (float-vector -20 0 (+ base-body-height 30)) :world)
    (send board2 :locate (float-vector -20 0 (+ base-body-height 30 15)) :world)
    (send board3 :locate (float-vector -20 -25  (+ base-body-height 30 15 50)) :world)
    (send board4 :locate (float-vector -20 -25  (+ base-body-height 30 15 50 35)) :world)
    ;;spacer������
    (send spacer1 :locate (float-vector  25 -60 base-body-height) :world)
    (send spacer2 :locate (float-vector  25  10 base-body-height) :world)
    (send spacer3 :locate (float-vector -65 -60 base-body-height) :world)
    (send spacer4 :locate (float-vector -65  10 base-body-height) :world)
    (send spacer5 :locate (float-vector  25  60 base-body-height) :world)
    (send spacer6 :locate (float-vector -65  60 base-body-height) :world)
    ;;
    #|
    (send psd1 :locate (float-vector  40 -100 (+ base-body-height 30)) :world)
    (send psd1 :rotate (deg2rad  60) :x)
    (send psd2 :locate (float-vector 100    0 (+ base-body-height 60)) :world)
    (send psd3 :locate (float-vector  40  100 (+ base-body-height 30)) :world)
    (send psd3 :rotate (deg2rad -60) :x)
    |#
    (send psd1 :locate (float-vector 80  -50 (+ base-body-height 30)) :world)
    (send psd2 :locate (float-vector 20  100 (+ base-body-height 30)) :world)
    (send psd2 :rotate (deg2rad -60) :x)
    (send psd3 :locate (float-vector -90 -50 (+ base-body-height 30)) :world)
    ;;(send psd3 :rotate (deg2rad  60) :x)

    ;;
    (send camera :locate #f(50 0 200))
    (send camera :rotate pi/2 :z)
    (send camera :rotate (deg2rad 100) :x)
    (send camera :rotate pi :z)
    ;;
    (dolist (b (list board1 board2 board3 board4))
      (setf (get b :face-color) :darkgreen))
    (dolist (b (list spacer1 spacer2 spacer3 spacer4 spacer5 spacer6))
      (setf (get b :face-color) :white))
    ;;
    (dolist (b (cons base-body parts))
      (send b :worldcoords))
    (dolist (b parts)
      (send base-body :assoc b))
    (setq daisya-base 
	  (instance bodyset-link :init (make-cascoords) 
				 :bodies (cons base-body parts)
				 :name :daisya-base))
    daisya-base))
;;
;; 2.��1��� (hinji - servo)����ʤ� ;; bodyset-link��Ȥ�
;;   hinji��servo�����äĤ��Ƥ��ʤ��Τϡ���ǥ����
;;   ����ʤΤϡ�l1����joint��Υ��Ƥ��뤳�ȤʤΤ��̤˵��ˤ��ʤ�
(defun make-daisya-l1 nil
  (let* ((l1 40)                ;;link1��Ĺ��
	 (hinji (make-hinji))
	 (servo (make-servo))
	 daisya-b1
         )
    ;;hinji��x��,z���ν�˲�ž
    (send hinji :rotate-vertices pi/2 :x)
    (send hinji :rotate-vertices pi/2 :z)
    ;;hinji��z�����˰�ư
    (send hinji :translate-vertices (float-vector 0 0 (* 0.25 (get hinji :hinji-width))))
    ;;
    ;;servo���ư (joint�ΰ��֤�l1��Ĺ���ˤ���褦��Ĵ��)
    (send servo :translate-vertices  (float-vector l1 (* 0.3 (get servo :servo-width)) 0))
    (send servo :worldcoords)
    (send hinji :worldcoords)
    (send hinji :assoc servo)
    (setq daisya-b1 (instance bodyset-link :init (make-cascoords) 
					   :bodies (list hinji servo) :name :daisya-b1))
    daisya-b1))
;;
;; 3.��2��� (hinji - hinji)����ʤ� 
(defun make-daisya-l2 nil
  (let* ((l2 50)                  ;;link2��Ĺ��
	 (hinji1 (make-hinji))
	 (hinji2 (make-hinji))
	 daisya-b2
         )
    ;;hinji1��y���˲�ž
    (send hinji1 :rotate-vertices pi/2 :y)
    ;;hinji2��y���˲�ž
    (send hinji2 :rotate-vertices (* -1 pi/2) :y)
    ;;hinji2��x������l2������ư
    (send hinji2 :translate-vertices (float-vector l2 0 0))
    (send hinji1 :worldcoords)
    (send hinji2 :worldcoords)
    (send hinji1 :assoc hinji2)
    (setq daisya-b2 (instance bodyset-link :init (make-cascoords) 
					   :bodies (list hinji1 hinji2) :name :daisya-b2))
    daisya-b2))
;;
;; 3.��3��� (servo - servo)����ʤ� Ĺ�������Τ˷��ꤵ��Ƥ��ʤ�
;;  ������L3�ϥϥ����ü�ޤǤ�Ĺ��
(defun make-daisya-l3 nil
  (let* ((servo1 (make-servo))
	 (servo2 (make-servo))
	 daisya-b3
         )
    ;;servo1��y���˲�ž
    (send servo1 :rotate-vertices pi/2 :y)
    (send servo2 :translate-vertices (float-vector 0 10 0))
    ;;servo2��z���˲�ž
    (send servo2 :rotate-vertices pi/2 :z)
    ;;servo2��x������servo������1.7��, ��ư
    (send servo2 :translate-vertices (float-vector (* 1.7 (get servo2 :servo-width)) -10 0))
    (send servo1 :worldcoords)
    (send servo2 :worldcoords)
    (send servo1 :assoc servo2)
    (setq daisya-b3 (instance bodyset-link :init (make-cascoords) 
					   :bodies (list servo1 servo2) :name :daisya-b3))
    daisya-b3))
;;
;; 4. ��4��� (servo - gripper)����ʤ� Ĺ�������Τ˷��ꤵ��Ƥ��ʤ�
;;  �����˽��
(defun make-daisya-l4 nil
  (let* ((servo (make-servo))
	 (gripper (make-gripper))
	 daisya-b4
         )
    ;;servo��x���˲�ž
    (send servo :rotate-vertices pi/2 :x)
    ;;servo���ư
    (send servo :translate-vertices (float-vector (* 0.5 (get servo :servo-depth)) 20 (* 0.4 (get servo :servo-width))))
    ;;gripper���ž
    (send gripper :rotate-vertices pi :x)
    ;;gripper���ư
    (send gripper :translate-vertices (float-vector (* 0.5 (get servo :servo-depth)) -10 (* 0.4 (get servo :servo-width))))
    ;;
    (send servo :worldcoords)
    (send gripper :worldcoords)
    (send servo :assoc gripper)
    (setq daisya-b4 (instance bodyset-link :init (make-cascoords) 
					   :bodies (list servo gripper) :name :daisya-b4))
    daisya-b4))
;; 5. hand��� gripper�Τߤ���ʤ�
(defun make-daisya-hand nil
  (let* ((gripper (make-gripper))
	 (servo (make-servo)) ;;servo�μ�����Τ���
	 daisya-b5
         )
    ;;gripper���ư
    (send gripper :translate-vertices (float-vector 0 0 (* 0.4 (get servo :servo-width))))
    (send gripper :worldcoords)
    (setq daisya-b5 (instance bodyset-link :init (make-cascoords) 
					   :bodies (list gripper) :name :daisya-hand))
    daisya-b5))
#|********************************
         link����� (�����ޤ�)
  ********************************|#


#|********************************
         ��֥��饹����� (��������)
  ********************************|#
(defun daisya 
  ()
  (setq *daisya* (instance daisyaclass :init)))

(defclass daisyaclass 
  :super robot-model
  :slots (arm-end-coords
	  joint0 joint1 joint2 joint3 joint-hand
          base sensors)
  )
(defmethod daisyaclass
  (:init
   (&rest args)
   (let (daisya-b0 daisya-b1 daisya-b2 daisya-b3 daisya-b4 daisya-hand
		   base-arm-pos
		   (l1 40) 
		   (l2 50) 
		   (l3 160)
		   (gripper-length 67)
		   )
     (send-super* :init args)

     ;;0.link����
     (setq daisya-b0 (make-daisya-base))
     (setq daisya-b1 (make-daisya-l1))
     (setq daisya-b2 (make-daisya-l2))
     (setq daisya-b3 (make-daisya-l3))
     (setq daisya-b4 (make-daisya-l4))
     (setq daisya-hand (make-daisya-hand))
     
     #| 
     ;;�����������ʤ뤫��Ȥꤢ���������ȥ�����
     (send daisya-b0 :bodies :set-color :limegreen)
     (send daisya-b1 :bodies :set-color :palegreen)
     (send daisya-b2 :bodies :set-color :royalblue)
     (send daisya-b3 :bodies :set-color :lightskyblue)
     (send daisya-b4 :bodies :set-color :orange)
     (send daisya-hand :bodies :set-color :blue)
     |#

     ;;1.link�����֤�Ԥ�
     ;; �ϥ�ɼ��Τϡ�daisya-b4����20mm��¦,10mm���ˤ���
     (send daisya-hand :transform (make-coords :pos (float-vector 10 20 0)))
     ;; �ϥ����ü�ϡ�daisya-b4����gripper-length��0.8�������Ȥ���
     (setq arm-end-coords (make-cascoords :pos (float-vector (* gripper-length 0.8) 0 0) :rpy (float-vector 0 0 pi)))
     ;; ������assoc,���֤��Ƥ���
     (send daisya-b4 :assoc arm-end-coords)
     (send daisya-b4 :assoc daisya-hand)
     ;; daisya-b4��daisya-b3��70mm��
     (send daisya-b4 :rotate pi :x)
     (send daisya-b4 :transform (make-coords :pos #f(70 0 -20)))
     (send daisya-b3 :assoc daisya-b4)
     ;; daisya-b3��daisya-b2��l2������
     (send daisya-b3 :transform (make-coords :pos (float-vector l2 0 0)))
     (send daisya-b2 :assoc daisya-b3)
     ;; daisya-b2��daisya-b1��l1������, ������     
     (send daisya-b2 :transform (make-coords :pos (float-vector l1 10 25)))
     (send daisya-b2 :rotate pi :x)
     (send daisya-b1 :assoc daisya-b2)
     ;; daisya-b1��daisya-b0��arm-base-pos������
     (setq arm-base-pos (get (car (send daisya-b0 :bodies)) :base-arm-pos))
     (send daisya-b1 :transform (make-coords :pos arm-base-pos))
     (send daisya-b0 :assoc daisya-b1)
     ;; ���
     ;; ��ʬ���Ȥ�assoc
     (send self :assoc daisya-b0)
     
     ;;2. joint������ (�������µ��Ȥ��äƤ��뤫����)
     (setq joint0 (instance rotational-joint :init :parent-link daisya-b0 :child-link daisya-b1 :name :joint0 :axis :z :min -80 :max 80))
     (setq joint1 (instance rotational-joint :init :parent-link daisya-b1 :child-link daisya-b2 :name :joint1 :axis :y :min -30 :max 90))
     (setq joint2 (instance rotational-joint :init :parent-link daisya-b2 :child-link daisya-b3 :name :joint2 :axis :y :min -90 :max 90))
     (setq joint3 (instance rotational-joint :init :parent-link daisya-b3 :child-link daisya-b4 :name :joint3 :axis :x :min -80 :max 80))
     (setq joint-hand (instance rotational-joint :init :parent-link daisya-b4 :child-link daisya-hand :name :joint-hand :axis :z :min -20 :max 90))
     ;;
     ;;3. slots�˳ƥ�󥯡�joint�򥻥å�
     (setq links (list
                  daisya-b0 daisya-b1 daisya-b2 daisya-b3 daisya-b4
                  daisya-hand))
     (setq joint-list (list
                       joint0 joint1 joint2 joint3
                       joint-hand))
     (setq collision-avoidance-links (list daisya-b2 daisya-b3 daisya-b4)) ;;�ʤ�daisya-b1, b0�Ϥʤ��Τ�?
     (send self :init-ending)

     ;;
     (setq sensors (mapcan #'(lambda (b) (if (derivedp b sensor-model) (list b))) bodies))
     self))
  ;; snnsor
  (:sensors (&optional cls) 
            (if cls
                (mapcan #'(lambda (b) (if (derivedp b cls) (list b))) sensors)
              sensors))
  (:simulate (objs) (send-all sensors :simulate objs))
  (:sensor-vector
   (cls)
   (coerce (send-all (mapcan #'(lambda (b) (if (derivedp b cls) (list b))) (send self :sensors)) :read) float-vector))
  (:bumper-vector () (send self :sensor-vector bumper-model))
  (:psd-vector () (send self :sensor-vector psd-model))
  (:camera-vector () (send self :camera :read))
  (:camera (&rest args)
           (forward-message-to (car (send self :sensors camera-model)) args))
  ;;
  ;;accessor
  (:joint0 (&rest args) (forward-message-to joint0 args))
  (:joint1 (&rest args) (forward-message-to joint1 args))
  (:joint2 (&rest args) (forward-message-to joint2 args))
  (:joint3 (&rest args) (forward-message-to joint3 args))
  (:joint-hand (&rest args) (forward-message-to joint-hand args))
  ;; limbs
  (:arm (&rest args)
        (unless args (setq args (list nil))) (send* self :limb :arm args))
  (:end-coords (&rest args) (forward-message-to arm-end-coords args))
  ;;IK��Ȥ��䤹���������ѹ�
  (:reset-pose
   ()
   ;;(send self :angle-vector #f(0 0 0   0.0 10.0 -40.0 0.0 0.0))
   (send self :angle-vector #f(0 -10.0 40.0 0.0 0.0))
   )
  (:tuckarm-pose
   ()
   (send self :angle-vector #f(80.0 90.0 0.0 0.0 0.0))
   )
  (:move-hand
   (angle)
   (send joint-hand :joint-angle angle))
  ;;���ޤ��ʤ�
  (:init-ending
   ()
   (setq bodies (flatten (send-all links :bodies)))
   (dolist (j joint-list)
     (send (send j :child-link) :add-joint j)
     (send (send j :child-link) :add-parent-link (send j :parent-link))
     (if (send j :parent-link)
	 (send (send j :parent-link) :add-child-links (send j :child-link)))
     )
   (send self :update-descendants))
  ;;
  ;;�Ӥ�ư����interface (���֤Ǥϻ��֤γ�ǰ������뤬������̤����)
  ;; ������Ϳ���ʤ��ȡ����߳��٤��֤�
  ;; (:arm-angle-vector
  ;;  (&optional aav (time 1000))
  ;;  (let* ((av (send self :angle-vector)))
  ;;    (cond 
  ;;     (aav
  ;;      (dotimes (i 5) (setf (aref av (+ i 3)) (aref aav i)))
  ;;      (send self :angle-vector av)
  ;;      aav)
  ;;     (t
  ;;      (subseq av 3)))
  ;;    ))
  ;;��֤��ư����interface (���֤Ǥϻ��֤γ�ǰ������뤬������̤����)
  ;; 
  (:move
   (mv &optional (time 1000))
   ;;�¿ʰ�ư��Ԥ���local��ɸ��
   (send self :locate (float-vector (aref mv 0) (aref mv 1) 0))
   ;;z������β�ž��Ԥ�(local��ɸ)
   (send self :rotate (deg2rad (aref mv 2)) :z)
   )
  )
;;
(defmethod daisyaclass
  (:open-hand 
   ()
   (let ((obj (get self :grasping-object)))
     (send (send self :arm :end-coords :parent) :dissoc obj)
     (setf (get self :grasping-object) nil)
     (send self :move-hand 50)))
  (:close-hand 
   (&optional obj)
   (if obj
       (progn
         (let (a)
           (setq a (send self :open-hand))
           (while (> a 0)
             (if (pqp-collision-check-objects
                  (list (send self :joint-hand :child-link)
                        (send self :joint3 :child-link))
                  (list obj))
                 (return))
             (send self :move-hand a)
             (decf a 1))
           (setf (get self :grasping-object) obj)
           (send (send self :arm :end-coords :parent) :assoc obj)))
     (send self :move-hand 0)))
  (:inverse-kinematics
   (target-coords &rest args &key (link-list)
                  (move-target) (stop 300)
                  (use-base nil) (start-coords (send self :copy-worldcoords))
                  (thre (cond
                         ((atom target-coords) 10)
                         (t (make-list (length target-coords) :initial-element 10))))
                  (rthre (cond
                         ((atom target-coords) (deg2rad 5))
                         (t (make-list (length target-coords) :initial-element (deg2rad 5)))))
                  (base-range (list :min #f(-30 -30 -30) :max #f( 30  30  30)))
                  &allow-other-keys)
   (let (diff-pos-rot)
     (unless move-target
       (setq move-target (send self :arm :end-coords)))
     (unless link-list
       (setq link-list (send self :link-list (send move-target :parent))))

     ;; use base
     (cond
      (use-base
       (setq diff-pos-rot
             (concatenate float-vector
                          (send start-coords :difference-position self)
                          (send start-coords :difference-rotation self)))
       (send self :move-to start-coords :world)
       (with-append-root-joint
        (ll self link-list
            :joint-class omniwheel-joint
            :joint-args base-range)
        (send (caar ll) :joint :joint-angle
              (float-vector (elt diff-pos-rot 0)
                            (elt diff-pos-rot 1)
                            (rad2deg (elt diff-pos-rot 5))))
        (send-super* :inverse-kinematics target-coords
                     :rthre rthre
                     :thre thre
                     :stop stop
                     :additional-weight-list
                     (list
                      (list (car (send self :links))
                            (if (eq use-base t) 1 use-base))
                      )
                     :link-list (car ll) ;; link-list
                     :move-target move-target
                    args)))
      (t
       (send-super* :inverse-kinematics target-coords
                    :rthre rthre
                    :thre thre
                    :stop stop
                    :link-list link-list
                    :move-target move-target
                    args))
       )))
  )
;;;
;;; Hanoi����ǻȤ����Ĥ��ࡢ�����Ȥ���ư��
;;; 
(defmethod cascaded-link
  (:pick
   (obj &rest args)
   (send self :open-hand)
   (prog1 
       (send* self :inverse-kinematics obj args)
     (send self :close-hand obj))
   )
  (:place
   (obj &rest args)
   (prog1
       (send* self :inverse-kinematics obj args)
     (send self :open-hand)))
  )