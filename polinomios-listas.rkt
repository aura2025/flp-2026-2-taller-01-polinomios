#lang eopl
;Autores: Valentina Valencia Lopez  2459626, Aura Maria Pelaez Luna 2459422

;; Taller 1 — Polinomios dispersos.
;; Parte 1: representación basada en listas.
;;
;; Interfaz del TAD. Cada función va comentada con su nombre, su contrato
;; (entrada -> salida) y su propósito, y ninguna recorre la lista de términos
;; más de una vez ni la ordena al final.
;;
;;   polinomio-cero    : symbol -> polinomio
;;   insertar-termino  : polinomio x coeficiente x exponente -> polinomio
;;   coeficiente-de    : polinomio x exponente -> coeficiente
;;   eliminar-termino  : polinomio x exponente -> polinomio


;; CONSTRUCTORES, PREDICADOS Y EXTRACTORES (REPRESENTACIÓN BASADA EN LISTAS)

;;-----------------------------------------------------------

;;poli(var, terms)

;;Constructor

;; poli : variable x terminos -> polinomio
;; Propósito: Construye un polinomio a partir de una variable y su estructura de términos.


(define poli
  (lambda (var terms)
    (list 'poli var terms)
    )
  )
;;Predicado

;; poli? : valor -> boolean
;; Propósito: Indica si un valor dado es un polinomio (construido con el constructor poli).


(define poli?
  (lambda (x)
    ( and (pair? x) (eq? (car x) 'poli))
    )
  )

;;Extractor

;; poli->var : polinomio -> variable
;; Propósito: Extrae la variable de un polinomio.

(define poli->var
  (lambda (p)
    (cadr p)
    )
  )

;; poli->terms : polinomio -> terminos
;; Propósito: Extrae la lista/estructura de términos de un polinomio.

(define poli->terms
  (lambda (p)
    (caddr p)
    )
  )

;;-----------------------------------------------------------

;;nombre-var(s)

;;Constructor

;; nombre-var : symbol -> variable
;; Propósito: Construye una variable a partir de un símbolo.

(define nombre-var
  (lambda (s)
    (list 'nombre-var s)
    )
  )

;;Predicado

;; nombre-var? : valor -> boolean
;; Propósito: Indica si un valor dado es una variable (construida con nombre-var).

(define nombre-var?
  (lambda (x)
    (and (pair? x) (eq?(car x) 'nombre-var))
    )
  )

;;Extractor

;; nombre-var->s : variable -> symbol
;; Propósito: Extrae el símbolo asociado a una variable.

(define nombre-var->s
  (lambda (nom)
    (cadr nom)
    )
  )

;;-----------------------------------------------------------

;;sin-terminos()


;;Constructor

;; sin-terminos : () -> terminos
;; Propósito: Construye la representación de una lista vacía de términos.

(define sin-terminos
  (lambda ()
    (list 'sin-terminos)
    )
  )

;;Predicado

;; sin-terminos? : valor -> boolean
;; Propósito: Indica si un valor representa la ausencia de términos (sin-terminos).

(define sin-terminos?
  (lambda (x)
    (and (pair? x) (eq?(car x) 'sin-terminos))
    )
  )


;;-----------------------------------------------------------

;;mas-terminos(term, resto)


;;Constructor

;; mas-terminos : termino x terminos -> terminos
;; Propósito: Agrega un término al inicio de una estructura de términos.

(define mas-terminos
  (lambda (term resto)
  (list 'mas-terminos term resto)
    )
  )

;;Predicado

;; mas-terminos? : valor -> boolean
;; Propósito: Indica si un valor representa una estructura con uno o más términos (mas-terminos).

(define mas-terminos?
  (lambda (x)
    (and (pair? x) (eq?(car x) 'mas-terminos))
    )
  )

;;Extractor

;; mas-terminos->term : terminos -> termino
;; Propósito: Extrae el primer término de una estructura mas-terminos.

(define mas-terminos->term
  (lambda (m-term)
    (cadr m-term)
    )
  )

;; mas-terminos->resto : terminos -> terminos
;; Propósito: Extrae el resto de los términos de una estructura mas-terminos.

(define mas-terminos->resto
  (lambda (m-term)
    (caddr m-term)
    )
  )

;;-----------------------------------------------------------

;;termino(coef, expo)

;;Constructor

;; termino : coeficiente x exponente -> termino
;; Propósito: Construye un término a partir de un coeficiente y un exponente.

(define termino
  (lambda (coef expo)
    (list 'termino coef expo)
    )
  )

;;Predicado

;; termino? : valor -> boolean
;; Propósito: Indica si un valor dado es un término.

(define termino?
  (lambda (x)
    (and (pair? x) (eq?(car x) 'termino))
    )
  )

;;Extractor

;; termino->coef : termino -> coeficiente
;; Propósito: Extrae el coeficiente de un término.

(define termino->coef
  (lambda (term)
    (cadr term)
    )
  )

;; termino->expo : termino -> exponente
;; Propósito: Extrae el exponente de un término.

(define termino->expo
  (lambda (term)
    (caddr term)
    )
  )

;;-----------------------------------------------------------

;;coef-ent(n)

;;Constructor

;; coef-ent : integer -> coeficiente
;; Propósito: Construye un coeficiente a partir de un número entero.

(define coef-ent
  (lambda (n)
    (list 'coef-ent n)
     )
  )

;; Predicado

;; coef-ent? : valor -> boolean
;; Propósito: Indica si un valor es un coeficiente entero (coef-ent).

(define coef-ent?
  (lambda (x)
    (and(pair? x)(eq? (car x) 'coef-ent))
    )
  )

;;Extractor

;; coef-ent->n : coeficiente -> integer
;; Propósito: Extrae el valor entero de un coeficiente entero.

(define coef-ent->n
  (lambda (coef-e)
    (cadr coef-e)
    )
  )


;;-----------------------------------------------------------

;;coef-rac(num,dem)

;;Constructor

;; coef-rac : integer x integer -> coeficiente
;; Propósito: Construye un coeficiente racional a partir de un numerador y un denominador.

(define coef-rac
  (lambda (num den)
    (list 'coef-rac num den)
    )
  )

;;Predicado

;; coef-rac? : valor -> boolean
;; Propósito: Indica si un valor es un coeficiente racional (coef-rac).

(define coef-rac?
  (lambda(x)
    (and(pair? x)(eq? (car x)'coef-rac))
    )
  )


;;Extractor

;; coef-rac->num : coeficiente -> integer
;; Propósito: Extrae el numerador de un coeficiente racional.

(define coef-rac->num
  (lambda (coef-r)
      (cadr coef-r)
      )
  )

;; coef-rac->den : coeficiente -> integer
;; Propósito: Extrae el denominador de un coeficiente racional.

(define coef-rac->den
  (lambda (coef-r)
      (caddr coef-r)
      )
  )

;;-----------------------------------------------------------

;;expo-nat(k)

;;Constructor

;; expo-nat : integer -> exponente
;; Propósito: Construye un exponente natural a partir de un entero no negativo.

(define expo-nat
  (lambda (k)
    (list 'expo-nat k)
    )
  )

;;Predicado

;; expo-nat? : valor -> boolean
;; Propósito: Indica si un valor es un exponente natural (expo-nat).

(define expo-nat?
  (lambda (x)
    (and (pair? x) (eq? (car x) 'expo-nat))
    )
  )

;;Extractor

;; expo-nat->k : exponente -> integer
;; Propósito: Extrae el número entero no negativo de un exponente natural.

(define expo-nat->k
  (lambda (expo-n)
    (cadr expo-n)
    )
  )





(provide polinomio-cero insertar-termino coeficiente-de eliminar-termino poli?)

;; polinomio-cero : symbol -> polinomio
;; Recibe un símbolo (el nombre de la variable) y retorna el polinomio nulo
;; (sin términos) en esa variable.

(define polinomio-cero
  (lambda (variable)
    (poli (nombre-var variable) (sin-terminos))
    )
  )



;; insertar-termino : polinomio x coeficiente x exponente -> polinomio
;; Recibe un polinomio, un coeficiente concreto y un exponente concreto.
;; Si el polinomio no tiene término con ese exponente, lo inserta en la
;; posición correspondiente según el orden decreciente. Si ya existe un
;; término con ese exponente, suma los coeficientes (y si la suma da cero,
;; el término desaparece). Genera un error si el exponente es negativo,
;; no es entero, o el coeficiente no es un número exacto.
  
(define insertar-termino
  (lambda (polinomio coeficiente exponente)
     (cond
      ;; ERROR: el exponente debe ser un numero entero
      [(not (integer? exponente))
       (eopl:error 'insertar-termino
                   "El exponente debe ser un numero entero")]

      ;; ERROR: el exponente no puede ser negativo
      [(< exponente 0)
       (eopl:error 'insertar-termino
                   "El exponente no puede ser negativo")]
      
      ;; ERROR: el coeficiente no puede ser un numero no exacto
      [(not (and(rational? coeficiente)(exact? coeficiente)))
       (eopl:error 'insertar-termino
                   "El coeficiente debe ser un numero exacto")]
      
      
      [(= coeficiente 0)
       polinomio]
       
      
       [else
       (let* ([terms (poli->terms polinomio)]
              [var (poli->var polinomio)]
              [coef (cond [(integer? coeficiente) (coef-ent coeficiente)]
                       [else (coef-rac (numerator coeficiente) (denominator coeficiente))]
                       )
                 ]
              [expo (expo-nat exponente)])
         
        ;;CASO A:  Lista de terminos vacia
           (cond [(sin-terminos? terms) (poli var (mas-terminos(termino coef expo)(sin-terminos)))]
                 [else
                 
                  (let*([primerTer (mas-terminos->term terms)]
                        [resto (mas-terminos->resto terms)]
                        [primer-coef (termino->coef primerTer)]
                        [coefSuelto (cond [(coef-ent? primer-coef) (coef-ent->n primer-coef)]
                                          [else (/(coef-rac->num primer-coef) (coef-rac->den primer-coef))])]
                       
                        [primer-expo (termino->expo primerTer)]
                        [expoSuelto (expo-nat->k primer-expo)]
                        )



                    (cond  

                      ;; CASO B: mismo exponente -> sumar coeficientes
                      [(= exponente expoSuelto)
                       (let* ([suma (+ coefSuelto coeficiente)])
                         (if (= suma 0)
                             (poli var resto)
                             (poli var (mas-terminos (termino (if (integer? suma) (coef-ent suma) (coef-rac (numerator suma) (denominator suma))) expo) resto))))]

           
                        
                      ;; CASO C: exponente mayor al exponente del primer termino -> se agrega de primero en la variable term      
                      [(> exponente expoSuelto)
                       (poli var (mas-terminos(termino coef expo) terms))]
                                                               
 
             
                      ;; CASO D: exponente es menor -> conservo el término actual y busco recursivamente dónde colocarlo.
                      [(< exponente expoSuelto)
                       (poli var (mas-terminos primerTer(poli->terms (insertar-termino (poli var resto) coeficiente exponente))))])
                    )]))])))
               
                          

;; coeficiente-de : polinomio x exponente -> coeficiente
;; Recibe un polinomio y un exponente concreto, y retorna el coeficiente
;; concreto del término con ese exponente. Genera un error si el exponente
;; no es válido o si el polinomio no tiene término con ese exponente.

(define coeficiente-de
  (lambda (polinomio exponente)
    (cond [(and (integer? exponente)(>= exponente 0))
          (let* ([terms (poli->terms polinomio)]
                 [var (poli->var polinomio)])
           ;;Lista de terminos vacia
          (cond [(sin-terminos? terms) (eopl:error 'coeficiente-de "No hay terminos para consultar su coeficiente")]
                [else(let*(
                 
                 [resto (mas-terminos->resto terms)]
                 [primerTer (mas-terminos->term terms)]
                 [expoSuelto (expo-nat->k (termino->expo primerTer))] 
                 [coefSuelto (cond [(coef-ent? (termino->coef primerTer)) (coef-ent->n (termino->coef primerTer))]
                                   [else( /(coef-rac->num (termino->coef primerTer)) (coef-rac->den (termino->coef primerTer)))])])

                  (cond
                    ;;;CASO A: El exponente es igual al exponente del primer termino
                    [(= exponente expoSuelto)  coefSuelto ]
                    ;;;CASO B: El exponente es menor al exponente del primer termino
                    [(< exponente expoSuelto) (coeficiente-de(poli var resto) exponente)]
                    ;;;CASO C: El exponente es mayor al exponente del primer termino
                    [(> exponente expoSuelto) (eopl:error 'coeficiente-de "El polinomio no tiene termino con ese exponente")]))]))]
                   
             
      
           [else (eopl:error 'coeficiente-de "No es un exponente valido")]
           )
    )
  )


;; eliminar-termino : polinomio x exponente -> polinomio
;; Recibe un polinomio y un exponente concreto, y retorna un polinomio
;; nuevo sin el término de ese exponente. Genera un error si el exponente
;; no es válido o si el término no existe.
 
(define eliminar-termino
  (lambda (polinomio exponente)

     (cond
      ;; ERROR: el exponente debe ser un numero entero
      [(not (integer? exponente))
       (eopl:error 'eliminar-termino
                   "El exponente debe ser un numero entero")]

      ;; ERROR: el exponente no puede ser negativo
      [(< exponente 0)
       (eopl:error 'eliminar-termino
                   "El exponente no puede ser negativo")]
      
    [else
          (let* ([terms (poli->terms polinomio)]
                 [var (poli->var polinomio)])
          (cond [(sin-terminos? terms) (eopl:error 'eliminar-termino "No hay terminos para eliminar")]
                [else(let*(
                 
                 [resto (mas-terminos->resto terms)]
                 [primerTer (mas-terminos->term terms)]
                 [expoSuelto (expo-nat->k (termino->expo primerTer))]) 
                 
                  (cond
                  ;;;CASO A: El exponente del termino a eliminar es igual al exponente del primer termino
                   [(= exponente expoSuelto) (poli var resto)]
                  ;;;CASO B:  El exponente del termino a eliminar es menor al exponente del primer termino
                   [(< exponente expoSuelto) (poli var (mas-terminos primerTer (poli->terms (eliminar-termino (poli var resto) exponente))))]
                  ;;;CASO C: El exponente del termino a eliminar es mayor al exponente del primer termino
                   [(> exponente expoSuelto) (eopl:error 'eliminar-termino "El polinomio no tiene termino con ese exponente")]))]))]


           
           )
    )
  )

;; --- Ejemplos de construcción con constructores y observadores ---

;; ;; Ejemplo 1: el polinomio nulo en x
;; (poli (nombre-var 'x) (sin-terminos))

;; ;; Ejemplo 2: un polinomio con un solo término, 5x^2
;; (poli (nombre-var 'x) (mas-terminos (termino (coef-ent 5) (expo-nat 2)) (sin-terminos)))

;; ;; Ejemplo 3: usando el observador poli->var
;; (poli->var (poli (nombre-var 'x) (sin-terminos)))            ;; -> (nombre-var x)

;; ;; Ejemplo 4: usando el predicado sin-terminos?
;; (sin-terminos? (sin-terminos))                                ;; -> #t

;; ;; Ejemplo 5: usando los extractores termino->coef y termino->expo
;; (termino->coef (termino (coef-rac -3 2) (expo-nat 2)))         ;; -> (coef-rac -3 2)
;; (termino->expo (termino (coef-rac -3 2) (expo-nat 2)))         ;; -> (expo-nat 2)


;; --- Ejemplos de uso: polinomio-cero ---
;; (polinomio-cero 'x)
;; (polinomio-cero 'y)
;; (polinomio-cero 't)
;; (poli? (polinomio-cero 'x))                                    ;; -> #t
;; (sin-terminos? (poli->terms (polinomio-cero 'x)))               ;; -> #t


;; --- Ejemplos de uso: insertar-termino ---
;; (define p
;;   (insertar-termino
;;     (insertar-termino
;;       (insertar-termino (polinomio-cero 'x) 7 0)
;;       -3/2 2)
;;     4 5))
;; p                                    ;; -> 4x^5 - (3/2)x^2 + 7

;; (insertar-termino p 1 2)             ;; -> -3/2 + 1 = -1/2, el término de exponente 2 cambia
;; (insertar-termino p 3/2 2)           ;; -> -3/2 + 3/2 = 0, el término de exponente 2 desaparece
;; (insertar-termino p 0 10)            ;; -> coeficiente 0, no altera el polinomio
;; ;; (insertar-termino p 5 -1)         ;; ERROR: "El exponente no puede ser negativo"
;; ;; (insertar-termino p 3.5 2)        ;; ERROR: "El coeficiente debe ser un numero exacto"


;; --- Ejemplos de uso: coeficiente-de ---
;; (coeficiente-de p 5)                 ;; -> 4
;; (coeficiente-de p 2)                 ;; -> -3/2
;; (coeficiente-de p 0)                 ;; -> 7
;; ;; (coeficiente-de (polinomio-cero 'x) 0)  ;; ERROR: "No hay terminos para consultar su coeficiente"
;; ;; (coeficiente-de p 3)              ;; ERROR: "El polinomio no tiene termino con ese exponente"


;; --- Ejemplos de uso: eliminar-termino ---
;; (eliminar-termino p 2)               ;; -> 4x^5 + 7
;; (eliminar-termino p 5)               ;; -> -3/2x^2 + 7
;; (eliminar-termino p 0)               ;; -> 4x^5 - 3/2x^2
;; ;; (eliminar-termino (polinomio-cero 'x) 0)  ;; ERROR: "No hay terminos para eliminar"
;; ;; (eliminar-termino p 3)             ;; ERROR: "El polinomio no tiene termino con ese exponente"