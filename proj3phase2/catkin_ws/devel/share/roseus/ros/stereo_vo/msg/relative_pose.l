;; Auto-generated. Do not edit!


(when (boundp 'stereo_vo::relative_pose)
  (if (not (find-package "STEREO_VO"))
    (make-package "STEREO_VO"))
  (shadow 'relative_pose (find-package "STEREO_VO")))
(unless (find-package "STEREO_VO::RELATIVE_POSE")
  (make-package "STEREO_VO::RELATIVE_POSE"))

(in-package "ROS")
;;//! \htmlinclude relative_pose.msg.html
(if (not (find-package "GEOMETRY_MSGS"))
  (ros::roseus-add-msgs "geometry_msgs"))
(if (not (find-package "STD_MSGS"))
  (ros::roseus-add-msgs "std_msgs"))


(defclass stereo_vo::relative_pose
  :super ros::object
  :slots (_header _key_stamp _relative_pose ))

(defmethod stereo_vo::relative_pose
  (:init
   (&key
    ((:header __header) (instance std_msgs::Header :init))
    ((:key_stamp __key_stamp) (instance ros::time :init))
    ((:relative_pose __relative_pose) (instance geometry_msgs::Pose :init))
    )
   (send-super :init)
   (setq _header __header)
   (setq _key_stamp __key_stamp)
   (setq _relative_pose __relative_pose)
   self)
  (:header
   (&rest __header)
   (if (keywordp (car __header))
       (send* _header __header)
     (progn
       (if __header (setq _header (car __header)))
       _header)))
  (:key_stamp
   (&optional __key_stamp)
   (if __key_stamp (setq _key_stamp __key_stamp)) _key_stamp)
  (:relative_pose
   (&rest __relative_pose)
   (if (keywordp (car __relative_pose))
       (send* _relative_pose __relative_pose)
     (progn
       (if __relative_pose (setq _relative_pose (car __relative_pose)))
       _relative_pose)))
  (:serialization-length
   ()
   (+
    ;; std_msgs/Header _header
    (send _header :serialization-length)
    ;; time _key_stamp
    8
    ;; geometry_msgs/Pose _relative_pose
    (send _relative_pose :serialization-length)
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; std_msgs/Header _header
       (send _header :serialize s)
     ;; time _key_stamp
       (write-long (send _key_stamp :sec) s) (write-long (send _key_stamp :nsec) s)
     ;; geometry_msgs/Pose _relative_pose
       (send _relative_pose :serialize s)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; std_msgs/Header _header
     (send _header :deserialize buf ptr-) (incf ptr- (send _header :serialization-length))
   ;; time _key_stamp
     (send _key_stamp :sec (sys::peek buf ptr- :integer)) (incf ptr- 4)  (send _key_stamp :nsec (sys::peek buf ptr- :integer)) (incf ptr- 4)
   ;; geometry_msgs/Pose _relative_pose
     (send _relative_pose :deserialize buf ptr-) (incf ptr- (send _relative_pose :serialization-length))
   ;;
   self)
  )

(setf (get stereo_vo::relative_pose :md5sum-) "5f31346257682659e34166a0fcbe1157")
(setf (get stereo_vo::relative_pose :datatype-) "stereo_vo/relative_pose")
(setf (get stereo_vo::relative_pose :definition-)
      "Header header
time key_stamp
geometry_msgs/Pose relative_pose

================================================================================
MSG: std_msgs/Header
# Standard metadata for higher-level stamped data types.
# This is generally used to communicate timestamped data 
# in a particular coordinate frame.
# 
# sequence ID: consecutively increasing ID 
uint32 seq
#Two-integer timestamp that is expressed as:
# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')
# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')
# time-handling sugar is provided by the client library
time stamp
#Frame this data is associated with
string frame_id

================================================================================
MSG: geometry_msgs/Pose
# A representation of pose in free space, composed of position and orientation. 
Point position
Quaternion orientation

================================================================================
MSG: geometry_msgs/Point
# This contains the position of a point in free space
float64 x
float64 y
float64 z

================================================================================
MSG: geometry_msgs/Quaternion
# This represents an orientation in free space in quaternion form.

float64 x
float64 y
float64 z
float64 w

")



(provide :stereo_vo/relative_pose "5f31346257682659e34166a0fcbe1157")


