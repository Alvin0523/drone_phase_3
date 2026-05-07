; Auto-generated. Do not edit!


(cl:in-package stereo_vo-msg)


;//! \htmlinclude relative_pose.msg.html

(cl:defclass <relative_pose> (roslisp-msg-protocol:ros-message)
  ((header
    :reader header
    :initarg :header
    :type std_msgs-msg:Header
    :initform (cl:make-instance 'std_msgs-msg:Header))
   (key_stamp
    :reader key_stamp
    :initarg :key_stamp
    :type cl:real
    :initform 0)
   (relative_pose
    :reader relative_pose
    :initarg :relative_pose
    :type geometry_msgs-msg:Pose
    :initform (cl:make-instance 'geometry_msgs-msg:Pose)))
)

(cl:defclass relative_pose (<relative_pose>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <relative_pose>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'relative_pose)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name stereo_vo-msg:<relative_pose> is deprecated: use stereo_vo-msg:relative_pose instead.")))

(cl:ensure-generic-function 'header-val :lambda-list '(m))
(cl:defmethod header-val ((m <relative_pose>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader stereo_vo-msg:header-val is deprecated.  Use stereo_vo-msg:header instead.")
  (header m))

(cl:ensure-generic-function 'key_stamp-val :lambda-list '(m))
(cl:defmethod key_stamp-val ((m <relative_pose>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader stereo_vo-msg:key_stamp-val is deprecated.  Use stereo_vo-msg:key_stamp instead.")
  (key_stamp m))

(cl:ensure-generic-function 'relative_pose-val :lambda-list '(m))
(cl:defmethod relative_pose-val ((m <relative_pose>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader stereo_vo-msg:relative_pose-val is deprecated.  Use stereo_vo-msg:relative_pose instead.")
  (relative_pose m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <relative_pose>) ostream)
  "Serializes a message object of type '<relative_pose>"
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'header) ostream)
  (cl:let ((__sec (cl:floor (cl:slot-value msg 'key_stamp)))
        (__nsec (cl:round (cl:* 1e9 (cl:- (cl:slot-value msg 'key_stamp) (cl:floor (cl:slot-value msg 'key_stamp)))))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __sec) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __sec) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __sec) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __sec) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 0) __nsec) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __nsec) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __nsec) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __nsec) ostream))
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'relative_pose) ostream)
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <relative_pose>) istream)
  "Deserializes a message object of type '<relative_pose>"
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'header) istream)
    (cl:let ((__sec 0) (__nsec 0))
      (cl:setf (cl:ldb (cl:byte 8 0) __sec) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) __sec) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) __sec) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) __sec) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 0) __nsec) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) __nsec) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) __nsec) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) __nsec) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'key_stamp) (cl:+ (cl:coerce __sec 'cl:double-float) (cl:/ __nsec 1e9))))
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'relative_pose) istream)
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<relative_pose>)))
  "Returns string type for a message object of type '<relative_pose>"
  "stereo_vo/relative_pose")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'relative_pose)))
  "Returns string type for a message object of type 'relative_pose"
  "stereo_vo/relative_pose")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<relative_pose>)))
  "Returns md5sum for a message object of type '<relative_pose>"
  "5f31346257682659e34166a0fcbe1157")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'relative_pose)))
  "Returns md5sum for a message object of type 'relative_pose"
  "5f31346257682659e34166a0fcbe1157")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<relative_pose>)))
  "Returns full string definition for message of type '<relative_pose>"
  (cl:format cl:nil "Header header~%time key_stamp~%geometry_msgs/Pose relative_pose~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%string frame_id~%~%================================================================================~%MSG: geometry_msgs/Pose~%# A representation of pose in free space, composed of position and orientation. ~%Point position~%Quaternion orientation~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%================================================================================~%MSG: geometry_msgs/Quaternion~%# This represents an orientation in free space in quaternion form.~%~%float64 x~%float64 y~%float64 z~%float64 w~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'relative_pose)))
  "Returns full string definition for message of type 'relative_pose"
  (cl:format cl:nil "Header header~%time key_stamp~%geometry_msgs/Pose relative_pose~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%string frame_id~%~%================================================================================~%MSG: geometry_msgs/Pose~%# A representation of pose in free space, composed of position and orientation. ~%Point position~%Quaternion orientation~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%================================================================================~%MSG: geometry_msgs/Quaternion~%# This represents an orientation in free space in quaternion form.~%~%float64 x~%float64 y~%float64 z~%float64 w~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <relative_pose>))
  (cl:+ 0
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'header))
     8
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'relative_pose))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <relative_pose>))
  "Converts a ROS message object to a list"
  (cl:list 'relative_pose
    (cl:cons ':header (header msg))
    (cl:cons ':key_stamp (key_stamp msg))
    (cl:cons ':relative_pose (relative_pose msg))
))
