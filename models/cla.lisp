(in-package :turtl)

(defvalidator validate-cla
  (("id" :type id :required t)
   ("type" :type string :required t)
   ("entity" :type string)
   ("fullname" :type string :required t)
   ("email" :type string :required t)
   ("address1" :type string :required t)
   ("address2" :type string)
   ("city" :type string :required t)
   ("state" :type string)
   ("zip" :type string)
   ("country" :type string :required t)
   ("phone" :type string :required t)
   ("github" :type string :required t)
   ("sign" :type string :required t)))

(adefun cla-sign (cla-data)
  "Sign the CLA."
  (unless (string= (hget cla-data '("sign")) "I AGREE")
    (error "Please type \"I AGREE\" into the signature field."))
  (let ((type (gethash "type" cla-data))
        (entity (or (gethash "entity" cla-data) "")))
    (when (and (string= type "ecla")
               (string= entity ""))
      (error "Please enter the Company/Organization/Entity name")))
  (add-id cla-data)
  (validate-cla (cla-data)
    (with-sock (sock :db "company")
      (alet* ((query (r:r (:insert
                            (:table "cla")
                            cla-data)))
              (nil (r:run sock query)))
        t))))



