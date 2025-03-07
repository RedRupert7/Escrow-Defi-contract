(define-map escrow
  ((buyer principal) (seller principal))
  ((amount uint) (status (string-ascii 10))))

(define-public (create-escrow (seller principal) (amount uint))
  (let ((existing (map-get? escrow { buyer: tx-sender, seller: seller })))
    (if existing
        (err "Escrow already exists")
        (begin
          (map-insert escrow { buyer: tx-sender, seller: seller }
                      { amount: amount, status: "pending" })
          (ok "Escrow created")))))

(define-public (fund-escrow (seller principal))
  (let ((escrow-data (map-get? escrow { buyer: tx-sender, seller: seller })))
    (match escrow-data
      escrow-entry
      (begin
        (stx-transfer? escrow-entry.amount tx-sender contract-principal)
        (map-set escrow { buyer: tx-sender, seller: seller }
                 { amount: escrow-entry.amount, status: "funded" })
        (ok "Escrow funded")))
      (err "Escrow not found")))

(define-public (release-funds (buyer principal))
  (let ((escrow-data (map-get? escrow { buyer: buyer, seller: tx-sender })))
    (match escrow-data
      escrow-entry
      (if (is-eq escrow-entry.status "funded")
          (begin
            (stx-transfer? escrow-entry.amount contract-principal tx-sender)
            (map-delete escrow { buyer: buyer, seller: tx-sender })
            (ok "Funds released"))
          (err "Funds not funded")))
      (err "Escrow not found"))))

(define-public (cancel-escrow (seller principal))
  (let ((escrow-data (map-get? escrow { buyer: tx-sender, seller: seller })))
    (match escrow-data
      escrow-entry
      (if (is-eq escrow-entry.status "pending")
          (begin
            (map-delete escrow { buyer: tx-sender, seller: seller })
            (ok "Escrow cancelled")))
          (err "Cannot cancel after funding")))
      (err "Escrow not found"))))

(define-public (dispute-escrow (buyer principal))
  (let ((escrow-data (map-get? escrow { buyer: buyer, seller: tx-sender })))
    (match escrow-data
      escrow-entry
      (begin
        (map-set escrow { buyer: buyer, seller: tx-sender }
                 { amount: escrow-entry.amount, status: "disputed" })
        (ok "Escrow disputed")))
      (err "Escrow not found"))))
(define-map escrow
  ((buyer principal) (seller principal))
  ((amount uint) (status (string-ascii 10))))

(define-map verified-users
  ((user principal))
  ((verified bool)))

(define-public (verify-user (user principal))
  (begin
    (map-insert verified-users { user: user } { verified: true })
    (ok "User verified")))

(define-read-only (is-verified (user principal))
  (default-to false (map-get? verified-users { user: user })))

(define-public (create-escrow (seller principal) (amount uint))
  (let ((existing (map-get? escrow { buyer: tx-sender, seller: seller })))
    (if existing
        (err "Escrow already exists")
        (begin
          (map-insert escrow { buyer: tx-sender, seller: seller }
                      { amount: amount, status: "pending" })
          (ok "Escrow created")))))

(define-public (fund-escrow (seller principal))
  (let ((escrow-data (map-get? escrow { buyer: tx-sender, seller: seller })))
    (match escrow-data
      escrow-entry
      (begin
        (stx-transfer? escrow-entry.amount tx-sender contract-principal)
        (map-set escrow { buyer: tx-sender, seller: seller }
                 { amount: escrow-entry.amount, status: "funded" })
        (ok "Escrow funded")))
      (err "Escrow not found"))))

(define-public (release-funds (buyer principal))
  (let ((escrow-data (map-get? escrow { buyer: buyer, seller: tx-sender })))
    (match escrow-data
      escrow-entry
      (if (is-eq escrow-entry.status "funded")
          (begin
            (stx-transfer-memo escrow-entry.amount contract-principal tx-sender "Escrow Release")
            (map-delete escrow { buyer: buyer, seller: tx-sender })
            (ok "Funds released"))
          (err "Funds not funded")))
      (err "Escrow not found"))))
(define-map escrow
  ((buyer principal) (seller principal))
  ((amount uint) (status (string-ascii 10))))

(define-map verified-users
  ((user principal))
  ((verified bool)))

(define-public (verify-user (user principal))
  (begin
    (map-insert verified-users { user: user } { verified: true })
    (ok "User verified")))

(define-read-only (is-verified (user principal))
  (default-to false (map-get? verified-users { user: user })))

(define-public (create-escrow (seller principal) (amount uint))
  (if (and (is-verified tx-sender) (is-verified seller))
      (let ((existing (map-get? escrow { buyer: tx-sender, seller: seller })))
        (if existing
            (err "Escrow already exists")
            (begin
              (map-insert escrow { buyer: tx-sender, seller: seller }
                          { amount: amount, status: "pending" })
              (ok "Escrow created")))))
      (err "Both users must be verified")))

(define-public (fund-escrow (seller principal))
  (if (is-verified tx-sender)
      (let ((escrow-data (map-get? escrow { buyer: tx-sender, seller: seller })))
        (match escrow-data
          escrow-entry
          (begin
            (stx-transfer-memo escrow-entry.amount tx-sender contract-principal "Escrow Funding")
            (map-set escrow { buyer: tx-sender, seller: seller }
                     { amount: escrow-entry.amount, status: "funded" })
            (ok "Escrow funded"))))
      (err "User not verified")))

(define-public (release-funds (buyer principal))
  (if (is-verified tx-sender)
      (let ((escrow-data (map-get? escrow { buyer: buyer, seller: tx-sender })))
        (match escrow-data
          escrow-entry
          (if (is-eq escrow-entry.status "funded")
              (begin
                (stx-transfer-memo escrow-entry.amount contract-principal tx-sender "Escrow Release")
                (map-delete escrow { buyer: buyer, seller: tx-sender })
                (ok "Funds released")))
              (err "Funds not funded")))
      (err "User not verified")))

(define-public (cancel-escrow (seller principal))
  (if (is-verified tx-sender)
      (let ((escrow-data (map-get? escrow { buyer: tx-sender, seller: seller })))
        (match escrow-data
          escrow-entry
          (if (is-eq escrow-entry.status "pending")
              (begin
                (map-delete escrow { buyer: tx-sender, seller: seller })
                (ok "Escrow cancelled"))))
          (err "Cannot cancel after funding")))
      (err "User not verified"))))
 