;; Asset Registration Contract
;; Records details of urban infrastructure

(define-data-var last-asset-id uint u0)

;; Asset types: 1=Road, 2=Bridge, 3=Building, 4=Utility, 5=Park
(define-map assets
  { asset-id: uint }
  {
    asset-type: uint,
    location: (string-utf8 100),
    installation-date: uint,
    last-maintenance: uint,
    status: uint, ;; 1=Operational, 2=Needs Maintenance, 3=Under Repair, 4=Decommissioned
    owner: principal
  }
)

(define-read-only (get-asset (asset-id uint))
  (map-get? assets { asset-id: asset-id })
)

(define-read-only (get-last-asset-id)
  (var-get last-asset-id)
)

(define-public (register-asset (asset-type uint) (location (string-utf8 100)) (installation-date uint))
  (let
    (
      (new-asset-id (+ (var-get last-asset-id) u1))
    )
    (asserts! (and (>= asset-type u1) (<= asset-type u5)) (err u1)) ;; Valid asset type
    (var-set last-asset-id new-asset-id)
    (map-set assets
      { asset-id: new-asset-id }
      {
        asset-type: asset-type,
        location: location,
        installation-date: installation-date,
        last-maintenance: installation-date,
        status: u1, ;; Operational by default
        owner: tx-sender
      }
    )
    (ok new-asset-id)
  )
)

(define-public (update-asset-status (asset-id uint) (new-status uint))
  (let
    (
      (asset (unwrap! (get-asset asset-id) (err u404)))
    )
    (asserts! (is-eq tx-sender (get owner asset)) (err u403))
    (asserts! (and (>= new-status u1) (<= new-status u4)) (err u2)) ;; Valid status
    (map-set assets
      { asset-id: asset-id }
      (merge asset { status: new-status })
    )
    (ok true)
  )
)

(define-public (record-maintenance (asset-id uint) (maintenance-date uint))
  (let
    (
      (asset (unwrap! (get-asset asset-id) (err u404)))
    )
    (asserts! (is-eq tx-sender (get owner asset)) (err u403))
    (map-set assets
      { asset-id: asset-id }
      (merge asset {
        last-maintenance: maintenance-date,
        status: u1 ;; Set back to operational
      })
    )
    (ok true)
  )
)

(define-public (transfer-ownership (asset-id uint) (new-owner principal))
  (let
    (
      (asset (unwrap! (get-asset asset-id) (err u404)))
    )
    (asserts! (is-eq tx-sender (get owner asset)) (err u403))
    (map-set assets
      { asset-id: asset-id }
      (merge asset { owner: new-owner })
    )
    (ok true)
  )
)
