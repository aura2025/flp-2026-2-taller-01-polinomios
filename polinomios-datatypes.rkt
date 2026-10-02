#lang eopl
;Autores: Valentina Valencia Lopez  2459626, Aura Maria Pelaez Luna 2459422

;; Taller 1 — Polinomios dispersos.
;; Parte 3: representación con datatypes.
;;
;; Interfaz del TAD. Cada función va comentada con su nombre, su contrato
;; (entrada -> salida) y su propósito, y ninguna recorre la lista de términos
;; más de una vez ni la ordena al final.
;;
;;   polinomio-cero    : symbol -> polinomio
;;   insertar-termino  : polinomio x coeficiente x exponente -> polinomio
;;   coeficiente-de    : polinomio x exponente -> coeficiente
;;   eliminar-termino  : polinomio x exponente -> polinomio
;;   sumar             : polinomio x polinomio -> polinomio



;; DEFINICIÓN DE DATATYPES (TIPOS DE DATOS ABSTRACTOS Y SUS CONSTRUCTORES)

;;-------------------------------------------------------

;;expo-nat(k)

;; entero-positivo? : valor -> boolean
;; Propósito: Predicado auxiliar que verifica si un valor es un entero mayor o igual a 0.

(define entero-positivo?
  (lambda (x)
    (and (integer? x) (>= x 0))
    )
  )

;; Datatype: exponente-tad
;; Predicado: exponente-tad? : valor -> boolean
;; Constructor:
;;   expo-nat : integer (>=0) -> exponente-tad
;; Propósito: Representa el exponente natural de un término dentro de la gramática.

(define-datatype exponente-tad exponente-tad?
  (expo-nat
   (k entero-positivo?)
   )
  )

;;--------------------------------------------------------

;;coeficiente

;; coef-ent(n)  coef-rac(num,den)

;; Datatype: coeficiente-tad
;; Predicado: coeficiente-tad? : valor -> boolean
;; Constructores:
;;   coef-ent : integer -> coeficiente-tad
;;   coef-rac : integer x integer -> coeficiente-tad
;; Propósito: Representa un coeficiente (ya sea entero o racional reducido) de un término.

(define-datatype coeficiente-tad coeficiente-tad?
  (coef-ent
   (n integer?)
   )
  (coef-rac
   (num integer?)
   (den integer?)
   )
  )

;;--------------------------------------------------------

;;termino

;;termino(coef, expo)

;; Datatype: termino-tad
;; Predicado: termino-tad? : valor -> boolean
;; Constructor:
;;   termino : coeficiente-tad x exponente-tad -> termino-tad
;; Propósito: Representa un término individual compuesto por un coeficiente y un exponente.

(define-datatype termino-tad termino-tad?
  (termino
   (coef coeficiente-tad?)
   (expo exponente-tad?)
   )
  )

;;--------------------------------------------------------

;;terminos

;;sin-terminos()  mas-terminos(term, resto)

;; Datatype: terminos
;; Predicado: terminos? : valor -> boolean
;; Constructores:
;;   sin-terminos : () -> terminos
;;   mas-terminos : termino-tad x terminos -> terminos
;; Propósito: Representa la estructura recursiva de la lista de términos de un polinomio.

(define-datatype terminos terminos?
  (sin-terminos)
  (mas-terminos
   (term termino-tad?)
   (resto terminos?)
   )
 )
;;--------------------------------------------------------

;;variable
;;nombre-var(s)

;; Datatype: variable
;; Predicado: variable? : valor -> boolean
;; Constructor:
;;   nombre-var : symbol -> variable
;; Propósito: Representa la variable algebraica asociada al polinomio.

(define-datatype variable variable?
  (nombre-var
   (s symbol?)
   )
 )

;;--------------------------------------------------------

;;polinomio
;;poli(var,terms)

;; Datatype: polinomio-tad
;; Predicado: polinomio-tad? : valor -> boolean
;; Constructor:
;;   poli : variable x terminos -> polinomio-tad
;; Propósito: Representa la estructura completa de un polinomio (variable y términos).

(define-datatype polinomio-tad polinomio-tad?
  (poli
   (var variable?)
   (terms terminos?)
   )
  )


;;--------------------------------------------------------

(provide polinomio-cero insertar-termino coeficiente-de eliminar-termino sumar polinomio-tad?)

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
;; Construye un polinomio de un solo término con ese coeficiente y exponente,
;; y lo combina con el original usando sumar. Genera un error si el exponente
;; es negativo, no es entero, o el coeficiente no es un número exacto.
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
       (cases polinomio-tad polinomio
         (poli (var terms)
              (sumar polinomio
                     (poli var
                           (mas-terminos
                            (termino(if(integer? coeficiente)
                                       (coef-ent coeficiente)
                                       (coef-rac (numerator coeficiente) (denominator coeficiente)))
                                    (expo-nat exponente))
                            (sin-terminos))))))])))
                                                       
                                                         
;; coeficiente-de : polinomio x exponente -> coeficiente
;; Recibe un polinomio y un exponente concreto, y retorna el coeficiente
;; concreto del término con ese exponente. Genera un error si el exponente
;; no es válido o si el polinomio no tiene término con ese exponente.                                                                                         
(define coeficiente-de
  (lambda (polinomio exponente)
    (cond
      ;; ERROR: el exponente debe ser un numero entero
      [(not (integer? exponente))
       (eopl:error 'coeficiente-de
                   "El exponente debe ser un numero entero")]

      ;; ERROR: el exponente no puede ser negativo
      [(< exponente 0)
       (eopl:error 'coeficiente-de
                   "El exponente no puede ser negativo")]
      
       
      
      [else(cases polinomio-tad polinomio
         (poli (var terms)  (cases terminos terms
                   ;;Lista de terminos vacia
                   (sin-terminos()(eopl:error 'coeficiente-de "No hay terminos para consultar su coeficiente"))
                   (mas-terminos(termPrimero resto)
                           (cases termino-tad termPrimero
                              (termino(coefPrimero expoPrimero)
                                      (let* ([expoSuelto (cases exponente-tad expoPrimero
                                                            (expo-nat (k) k))]
                                             [coefSuelto (cases coeficiente-tad coefPrimero
                                                            (coef-ent (n) n)
                                                             (coef-rac (num den) (/ num den)))])
   
          

                  (cond
                    ;;;CASO A: El exponente es igual al exponente del primer termino
                    [(= exponente expoSuelto)  coefSuelto ]
                    ;;;CASO B: El exponente es menor al exponente del primer termino
                    [(< exponente expoSuelto) (coeficiente-de(poli var resto) exponente)]
                    ;;;CASO C: El exponente es mayor al exponente del primer termino
                    [(> exponente expoSuelto) (eopl:error 'coeficiente-de "El polinomio no tiene termino con ese exponente")]))))))))])))
                   
             
      
           
                                     


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
      
       
      
      [else(cases polinomio-tad polinomio
         (poli (var terms)  (cases terminos terms
                   ;;CASO A: Lista de terminos vacia
                   (sin-terminos()(eopl:error 'eliminar-termino "No hay terminos para eliminar"))
                   (mas-terminos(termPrimero resto)
                           (cases termino-tad termPrimero
                              (termino(coefPrimero expoPrimero)
                                      (let* ([expoSuelto (cases exponente-tad expoPrimero
                                                            (expo-nat (k) k))])
                                             
   
                 
                  (cond
                  ;;;CASO B: El exponente del termino a eliminar es igual al exponente del primer termino
                   [(= exponente expoSuelto) (poli var resto)]
                  ;;;CASO C:  El exponente del termino a eliminar es menor al exponente del primer termino
                   [(< exponente expoSuelto) (cases polinomio-tad (eliminar-termino (poli var resto) exponente)
                                                                         (poli (varRec termsRec) (poli var (mas-terminos termPrimero termsRec))))]

                  ;;;CASO D: El exponente del termino a eliminar es mayor al exponente del primer termino
                   [(> exponente expoSuelto) (eopl:error 'eliminar-termino "El polinomio no tiene termino con ese exponente")]))))))))])))


;; sumar : polinomio x polinomio -> polinomio
;; Recibe dos polinomios en la misma variable, y retorna su suma. Los
;; términos con exponentes iguales se combinan sumando coeficientes, y los
;; que se cancelan desaparecen del resultado. Recorre las dos listas de
;; términos en paralelo, una sola vez. Genera un error si los polinomios
;; no están en la misma variable.           
(define sumar
  (lambda (p q)
    (cases polinomio-tad p
      (poli(varP termsP)
        (cases polinomio-tad q
          (poli(varQ termsQ)

              ;;Verificacion de igual variable
               (cond[(not(eq? (cases variable varP ( nombre-var(s) s)) 
                              (cases variable varQ ( nombre-var(s) s))))
                     (eopl:error 'sumar "Los polinomios deben estar en la misma variable")]
                    ;; sumar terminos 
                    [else
                    ;;funcion local sumar-terminos
                     (letrec
                         ([sumar-terminos
                           (lambda (termsP termsQ)

                             (cases terminos termsP
                               (sin-terminos() termsQ)
                               (mas-terminos( termP restoP)
                                    (cases terminos termsQ
                                      (sin-terminos() termsP)
                                       (mas-terminos( termQ restoQ)
                                                    (cases termino-tad termP
                                                      (termino (coefP expoP)
                                                          (cases termino-tad termQ
                                                            (termino (coefQ expoQ)
                                                              (let([ kP  (cases exponente-tad expoP (expo-nat(k) k))]
                                                                   [ kQ (cases exponente-tad expoQ (expo-nat(k) k))]
                                                                   [ cP  (cases coeficiente-tad coefP
                                                                           (coef-ent(n) n)
                                                                           (coef-rac(num den) (/ num den)))]
                                                                   [ cQ (cases coeficiente-tad coefQ
                                                                           (coef-ent(n)n)
                                                                           (coef-rac(num den) (/ num den)))])

                                                                   (cond

                                                                     ;;CASO A: el exponente de termP es mayor
                                                                   [(> kP kQ)(mas-terminos termP (sumar-terminos restoP termsQ))]
                                                                     ;;CASO B: el exponente de termQ es mayor
                                                                   [(< kP kQ)(mas-terminos termQ (sumar-terminos termsP restoQ))]
                                                                     ;;CASO C: exponentes iguales se suman

                                                                   [else
                                                                    (let([suma(+ cP cQ)])
                                                                      (if (= suma 0)
                                                                          (sumar-terminos restoP restoQ)
                                                                          (mas-terminos
                                                                           (termino (if(integer? suma)
                                                                                       (coef-ent suma)
                                                                                       (coef-rac (numerator suma) (denominator suma)))
                                                                                    expoP)
                                                                           (sumar-terminos restoP restoQ))
                                                                        )
                                                                      )
                                                                    ]
                                                                   )))))))))))])
                       (poli varP (sumar-terminos termsP termsQ)))])))))))




;; --- Ejemplos de construcción con los constructores del datatype ---

;; Ejemplo 1: el polinomio nulo en x
;; (poli (nombre-var 'x) (sin-terminos))

;; Ejemplo 2: un polinomio con un solo término, 5x^2
;; (poli (nombre-var 'x) (mas-terminos (termino (coef-ent 5) (expo-nat 2)) (sin-terminos)))

;; Ejemplo 3: un término con coeficiente racional
;; (termino (coef-rac -3 2) (expo-nat 2))

;; Ejemplo 4: un termino con coeficiente entero y exponente 0 (término independiente)
;; (termino (coef-ent 7) (expo-nat 0))

;; Ejemplo 5: una lista de dos términos encadenados con mas-terminos
;; (mas-terminos (termino (coef-ent 4) (expo-nat 5))
;;   (mas-terminos (termino (coef-ent 7) (expo-nat 0))
;;     (sin-terminos)))




;; --- Ejemplos de uso: polinomio-cero ---
;; (polinomio-cero 'x)
;; (polinomio-cero 'y)
;; (polinomio-cero 't)

;; --- Ejemplos de uso: insertar-termino ---
;; (insertar-termino (polinomio-cero 'x) 7 0)
;; (insertar-termino (insertar-termino (polinomio-cero 'x) 7 0) -3/2 2)
;; (insertar-termino
;;   (insertar-termino
;;     (insertar-termino (polinomio-cero 'x) 7 0)
;;     -3/2 2)
;;   4 5)

;; --- Ejemplos de uso: coeficiente-de ---
;; (define p-ejemplo
;;   (insertar-termino
;;     (insertar-termino
;;       (insertar-termino (polinomio-cero 'x) 7 0)
;;       -3/2 2)
;;     4 5))
;; (coeficiente-de p-ejemplo 5)    ;; -> 4
;; (coeficiente-de p-ejemplo 2)    ;; -> -3/2
;; (coeficiente-de p-ejemplo 0)    ;; -> 7

;; --- Ejemplos de uso: eliminar-termino ---
;; (eliminar-termino p-ejemplo 2)  ;; -> 4x^5 + 7
;; (eliminar-termino p-ejemplo 5)  ;; -> -3/2x^2 + 7
;; (eliminar-termino p-ejemplo 0)  ;; -> 4x^5 - 3/2x^2

;; --- Ejemplos de uso: sumar ---
;; (define q-ejemplo
;;   (insertar-termino
;;     (insertar-termino
;;       (insertar-termino (polinomio-cero 'x) -4 5)
;;       1/2 2)
;;     2 1))
;; (sumar p-ejemplo q-ejemplo)     ;; -> -x^2 + 2x + 7
;; (sumar p-ejemplo p-ejemplo)     ;; -> 8x^5 - 3x^2 + 14
;; (sumar p-ejemplo (polinomio-cero 'x))  ;; -> igual a p-ejemplo
