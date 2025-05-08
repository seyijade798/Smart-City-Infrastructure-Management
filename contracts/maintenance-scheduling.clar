;; Sensor Network Contract
;; Manages IoT devices monitoring conditions

(define-data-var last-sensor-id uint u0)

;; Sensor types: 1=Temperature, 2=Humidity, 3=Air Quality, 4=Traffic, 5=Noise, 6=Water Level
(define-map sensors
  { sensor-id: uint }
  {
    sensor-type: uint,
    location: (string-utf8 100),
    asset-id: uint, ;; Associated infrastructure asset
    installation-date: uint,
    last-reading-time: uint,
    status: uint, ;; 1=Active, 2=Inactive, 3=Maintenance
    owner: principal
  }
)

(define-map sensor-readings
  { sensor-id: uint, timestamp: uint }
  {
    reading-value: int,
    reading-unit: (string-utf8 10),
    reported-by: principal
  }
)

(define-read-only (get-sensor (sensor-id uint))
  (map-get? sensors { sensor-id: sensor-id })
)

(define-read-only (get-last-sensor-id)
  (var-get last-sensor-id)
)

(define-read-only (get-sensor-reading (sensor-id uint) (timestamp uint))
  (map-get? sensor-readings { sensor-id: sensor-id, timestamp: timestamp })
)

(define-public (register-sensor (sensor-type uint) (location (string-utf8 100)) (asset-id uint))
  (let
    (
      (new-sensor-id (+ (var-get last-sensor-id) u1))
    )
    (asserts! (and (>= sensor-type u1) (<= sensor-type u6)) (err u1)) ;; Valid sensor type
    (var-set last-sensor-id new-sensor-id)
    (map-set sensors
      { sensor-id: new-sensor-id }
      {
        sensor-type: sensor-type,
        location: location,
        asset-id: asset-id,
        installation-date: block-height,
        last-reading-time: u0,
        status: u1, ;; Active by default
        owner: tx-sender
      }
    )
    (ok new-sensor-id)
  )
)

(define-public (record-sensor-reading (sensor-id uint) (reading-value int) (reading-unit (string-utf8 10)))
  (let
    (
      (sensor (unwrap! (get-sensor sensor-id) (err u404)))
      (timestamp block-height)
    )
    ;; Only allow readings if sensor is active
    (asserts! (is-eq (get status sensor) u1) (err u2))

    ;; Record the reading
    (map-set sensor-readings
      { sensor-id: sensor-id, timestamp: timestamp }
      {
        reading-value: reading-value,
        reading-unit: reading-unit,
        reported-by: tx-sender
      }
    )

    ;; Update the last reading time
    (map-set sensors
      { sensor-id: sensor-id }
      (merge sensor { last-reading-time: timestamp })
    )

    (ok timestamp)
  )
)

(define-public (update-sensor-status (sensor-id uint) (new-status uint))
  (let
    (
      (sensor (unwrap! (get-sensor sensor-id) (err u404)))
    )
    (asserts! (is-eq tx-sender (get owner sensor)) (err u403))
    (asserts! (and (>= new-status u1) (<= new-status u3)) (err u2)) ;; Valid status
    (map-set sensors
      { sensor-id: sensor-id }
      (merge sensor { status: new-status })
    )
    (ok true)
  )
)
