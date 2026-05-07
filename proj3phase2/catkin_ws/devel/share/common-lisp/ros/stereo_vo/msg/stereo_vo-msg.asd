
(cl:in-package :asdf)

(defsystem "stereo_vo-msg"
  :depends-on (:roslisp-msg-protocol :roslisp-utils :geometry_msgs-msg
               :std_msgs-msg
)
  :components ((:file "_package")
    (:file "relative_pose" :depends-on ("_package_relative_pose"))
    (:file "_package_relative_pose" :depends-on ("_package"))
  ))