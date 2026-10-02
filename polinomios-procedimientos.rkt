#lang eopl
;Autores: Valentina Valencia Lopez  2459626, Aura Maria Pelaez Luna 2459422

;; Taller 1 — Polinomios dispersos.
;; Parte 2: representación basada en procedimientos.
;;
;; Interfaz del TAD. Cada función va comentada con su nombre, su contrato
;; (entrada -> salida) y su propósito, y ninguna recorre la lista de términos
;; más de una vez ni la ordena al final.
;;
;;   polinomio-cero    : symbol -> polinomio
;;   insertar-termino  : polinomio x coeficiente x exponente -> polinomio
;;   coeficiente-de    : polinomio x exponente -> coeficiente
;;   eliminar-termino  : polinomio x exponente -> polinomio


;; CONSTRUCTORES, PREDICADOS Y EXTRACTORES (REPRESENTACIÓN BASADA EN PROCEDIMIENTOS)

;;-----------------------------------------------------------------


;;poli(var, terms)

;; Constructor

;; poli : variable x terminos -> polinomio
;; Propósito: Construye un polinomio representado por un procedimiento que responde a mensajes.

(define poli
  (lambda(var terms)
    (lambda(mensaje)
      (cond
        [(eq? mensaje 'tipo) 'poli]
        [(eq? mensaje 'var) var]
        [(eq? mensaje 'terms) terms]
        [else(eopl:error 'poli "Mensaje desconocido: ~s" mensaje)]

       )
      )
    )
  )

;;Predicado

;; poli? : valor -> boolean
;; Propósito: Indica si un valor dado es un polinomio procedimental.

(define poli?
  (lambda(x)
    (and(procedure? x)
        (eq? (x 'tipo) 'poli)
        )
    )
  )

;;Extractor

;; poli->var : polinomio -> variable
;; Propósito: Extrae la variable de un polinomio procedimental

(define poli->var
  (lambda (p)
    (p 'var)
    )
  )
;; poli->terms : polinomio -> terminos
;; Propósito: Extrae los términos de un polinomio procedimental.

(define poli->terms
  (lambda(p)
    (p 'terms)
    )
  )

;;----------------------------------------------

;;nombre-var(s)

;;Constructor

;; nombre-var : symbol -> variable
;; Propósito: Construye una variable como procedimiento a partir de un símbolo.

(define nombre-var
  (lambda (s)
    (lambda(mensaje)
    (cond
      [(eq? mensaje 'tipo) 'nombre-var]
      [(eq? mensaje 's) s]
      [else(eopl:error 'nombre-var "Mensaje desconocido: ~s" mensaje)]
      )
     )
    )
  )
;;Predicado

;; nombre-var? : valor -> boolean
;; Propósito: Indica si un valor dado es una variable procedimental.

(define nombre-var?
  (lambda(x)
    (and(procedure? x)
        (eq? (x 'tipo) 'nombre-var)
    )
    )
  )

;;Extractor

;; nombre-var->s : variable -> symbol
;; Propósito: Extrae el símbolo de una variable procedimental.

(define nombre-var->s
  (lambda(nom)
    (nom 's)
    )
  )

;;----------------------------------------------

;;sin-terminos()

;;Constructor

;; sin-terminos : () -> terminos
;; Propósito: Construye la representación procedimental de la ausencia de términos.

(define sin-terminos
  (lambda ()
    (lambda (mensaje)
    (cond
      [(eq? mensaje 'tipo) 'sin-terminos]
      [else(eopl:error 'sin-terminos "Mensaje desconocido: ~s" mensaje)]
      )
     )
    )
  )

;;Predicado

;; sin-terminos? : valor -> boolean
;; Propósito: Indica si un valor representa la ausencia de términos procedimental.

(define sin-terminos?
  (lambda(x)
    (and(procedure? x)
        (eq? (x 'tipo) 'sin-terminos)
        )
    )
  )
;;-------------------------------
;;mas-terminos(term, resto)

;;Constructor

;; mas-terminos : termino x terminos -> terminos
;; Propósito: Construye una estructura procedimental con un término y el resto de los términos.

(define mas-terminos
  (lambda (term resto)
    (lambda (mensaje)
    (cond
      [(eq? mensaje 'tipo) 'mas-terminos]
      [(eq? mensaje 'term) term]
      [(eq? mensaje 'resto) resto]
      [else(eopl:error 'mas-terminos "Mensaje desconocido: ~s" mensaje)]
      )
     )
    )
  )

;;Predicado

;; mas-terminos? : valor -> boolean
;; Propósito: Indica si un valor es una estructura mas-terminos procedimental.

(define mas-terminos?
  (lambda (x)
    (and(procedure? x)
        (eq? (x 'tipo) 'mas-terminos)
        )
    )
  )

;;Extractor

;; mas-terminos->term : terminos -> termino
;; Propósito: Extrae el primer término de una estructura mas-terminos procedimental.

(define mas-terminos->term
  (lambda(mas-t)
    (mas-t 'term)
    )
  )

;; mas-terminos->resto : terminos -> terminos
;; Propósito: Extrae el resto de los términos de una estructura mas-terminos procedimental.

(define mas-terminos->resto
  (lambda(mas-t)
    (mas-t 'resto)
    )
  )

;;----------------------------------------------

;;termino(coef, expo)

;;Constructor

;; termino : coeficiente x exponente -> termino
;; Propósito: Construye un término procedimental a partir de un coeficiente y un exponente.

(define termino
  (lambda (coef expo)
    (lambda (mensaje)
      (cond
      [(eq? mensaje 'tipo) 'termino]
      [(eq? mensaje 'coef) coef]
      [(eq? mensaje 'expo) expo]
      
       [else (eopl:error 'termino "Mensaje desconocido: ~s" mensaje)]
       )
      )
    )
  )

;;Predicado

;; termino? : valor -> boolean
;; Propósito: Indica si un valor es un término procedimental.

(define termino?
  (lambda (x)
    (and(procedure? x)
        (eq? (x 'tipo) 'termino)
        )
    )
  )

;;Extractor


;; termino->coef : termino -> coeficiente
;; Propósito: Extrae el coeficiente de un término procedimental.

(define termino->coef
  (lambda (c)
    (c 'coef)
    )
  )

;; termino->expo : termino -> exponente
;; Propósito: Extrae el exponente de un término procedimental.

(define termino->expo
  (lambda (e)
    (e 'expo)
    )
  )
;;-------------------------------------------------
;;coef-ent(n)

;;Constructor

;; coef-ent : integer -> coeficiente
;; Propósito: Construye un coeficiente entero procedimental.

(define coef-ent
  (lambda (n)
    (lambda (mensaje)
      (cond
      [(eq? mensaje 'tipo) 'coef-ent]
      [(eq? mensaje 'n) n]
      [else (eopl:error 'coef-ent "Mensaje desconocido: ~s" mensaje)]
       )
      )
    )
  )

;;Predicado

;; coef-ent? : valor -> boolean
;; Propósito: Indica si un valor es un coeficiente entero procedimental.

(define coef-ent?
  (lambda (x)
    (and(procedure? x)
        (eq? (x 'tipo) 'coef-ent)
        )
    )
)

;;Extractor

;; coef-ent->n : coeficiente -> integer
;; Propósito: Extrae el valor entero de un coeficiente entero procedimental.

(define coef-ent->n
  (lambda (ce)
    (ce 'n)
    )
  )
;;----------------------------------------

;;coef-rac(num,den)

;;Constructor

;; coef-rac : integer x integer -> coeficiente
;; Propósito: Construye un coeficiente racional procedimental a partir de numerador y denominador.

(define coef-rac
  (lambda (num den)
    (lambda (mensaje)
      (cond
      [(eq? mensaje 'tipo) 'coef-rac]
      [(eq? mensaje 'num) num]
      [(eq? mensaje 'den) den]
      [else (eopl:error 'coef-rac "Mensaje desconocido: ~s" mensaje)]
       )
      )
    )
  )

;;Predicado

;; coef-rac? : valor -> boolean
;; Propósito: Indica si un valor es un coeficiente racional procedimental.

(define coef-rac?
  (lambda (x)
    (and(procedure? x)
        (eq? (x 'tipo) 'coef-rac)
        )
    )
)

;;Extractor

;; coef-rac->num : coeficiente -> integer
;; Propósito: Extrae el numerador de un coeficiente racional procedimental.

(define coef-rac->num
  (lambda (cr)
    (cr 'num)
    )
  )

;; coef-rac->den : coeficiente -> integer
;; Propósito: Extrae el denominador de un coeficiente racional procedimental.

(define coef-rac->den
  (lambda (cr)
    (cr 'den)
    )
  )
;;---------------------------------
;;expo-nat(k)

;;Exponente

;; expo-nat : integer -> exponente
;; Propósito: Construye un exponente natural procedimental.

(define expo-nat
  (lambda (k)
    (lambda(mensaje)
      (cond
        [(eq? mensaje 'tipo) 'expo-nat]
        [(eq? mensaje 'k) k]
        [else(eopl:error 'expo-nat "Mensaje desconocido: ~s" mensaje)]

       )
      )
    
    )
  )

;;Predicado

;; expo-nat? : valor -> boolean
;; Propósito: Indica si un valor es un exponente natural procedimental.

(define expo-nat?
  (lambda(x)
    (and(procedure? x)
        (eq? (x 'tipo) 'expo-nat)
        
        )
    )
  )

;;Extractor

;; expo-nat->k : exponente -> integer
;; Propósito: Extrae el valor entero de un exponente natural procedimental.

(define expo-nat->k
  (lambda(expo-n)
    (expo-n 'k)
    )
  )


