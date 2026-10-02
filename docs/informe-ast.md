# Informe de AST — Taller 1: Un TAD con tres caras

**Autores:** Valentina Valencia Lopez (2459626), Aura Maria Pelaez Luna (2459422)

## 0. Gramática y convenciones

La gramática del TAD es:

```
<polinomio>    ::= <variable> <terminos>          poli(var, terms)
<variable>     ::= <symbol>                        nombre-var(s)
<terminos>     ::= '()                             sin-terminos()
                 | <termino> <terminos>            mas-terminos(term, resto)
<termino>      ::= <coeficiente> <exponente>       termino(coef, expo)
<coeficiente>  ::= <int>                           coef-ent(n)
                 | <int> "/" <int>                 coef-rac(num, den)
<exponente>    ::= <int>                           expo-nat(k)
```

Convenciones de los diagramas:

- Cada nodo interno lleva el nombre de un constructor de la gramática.
- Las hojas (`s`, `n`, `num`, `den`, `k`) llevan el valor concreto que guarda el campo.
- Los hijos de `mas-terminos` se leen de izquierda a derecha: primero `term` y después `resto`.
- Los términos aparecen en orden estrictamente decreciente de exponente (invariante del TAD).

---

## 1. Polinomio de un solo término con coeficiente entero

Polinomio: $p_1(x) = 5x^2$.

Dato: `(poli (nombre-var 'x) (mas-terminos (termino (coef-ent 5) (expo-nat 2)) (sin-terminos)))`

```mermaid
graph TD
    A["poli"] --> B["nombre-var"]
    A --> C["mas-terminos"]
    B --> B1["s = x"]
    C --> D["termino"]
    C --> E["sin-terminos"]
    D --> F["coef-ent"]
    D --> G["expo-nat"]
    F --> F1["n = 5"]
    G --> G1["k = 2"]
```

**Lectura:** la raíz `poli` tiene dos hijos: la variable `x` y la lista de términos. La lista tiene un único `mas-terminos`, cuyo `resto` es `sin-terminos` (lista vacía), y cuyo `term` es el término $5x^2$.

---

## 2. Polinomio de dos términos, uno con coeficiente racional

Polinomio: $p_2(x) = -\tfrac{3}{2}x^2 + 4x$.

Dato:
```
(poli (nombre-var 'x)
  (mas-terminos (termino (coef-rac -3 2) (expo-nat 2))
    (mas-terminos (termino (coef-ent 4) (expo-nat 1))
      (sin-terminos))))
```

```mermaid
graph TD
    A["poli"] --> B["nombre-var"]
    A --> C["mas-terminos"]
    B --> B1["s = x"]
    C --> D["termino"]
    C --> H["mas-terminos"]
    D --> E["coef-rac"]
    D --> G["expo-nat"]
    E --> E1["num = -3"]
    E --> E2["den = 2"]
    G --> G1["k = 2"]
    H --> I["termino"]
    H --> L["sin-terminos"]
    I --> J["coef-ent"]
    I --> K["expo-nat"]
    J --> J1["n = 4"]
    K --> K1["k = 1"]
```

**Lectura:** el coeficiente racional se guarda con `coef-rac`, con numerador y denominador por separado como hojas (`num = -3`, `den = 2`). El coeficiente entero usa `coef-ent`. Los dos términos están encadenados con dos `mas-terminos` y el primero tiene el exponente mayor.

---

## 3. Polinomio de tres o más términos con término independiente

Polinomio: $p(x) = 4x^5 - \tfrac{3}{2}x^2 + 7$ (el mismo de la Parte 3 del taller).

Dato:
```
(poli (nombre-var 'x)
  (mas-terminos (termino (coef-ent 4) (expo-nat 5))
    (mas-terminos (termino (coef-rac -3 2) (expo-nat 2))
      (mas-terminos (termino (coef-ent 7) (expo-nat 0))
        (sin-terminos)))))
```

```mermaid
graph TD
    A["poli"] --> B["nombre-var"]
    A --> C["mas-terminos"]
    B --> B1["s = x"]
    C --> D["termino"]
    C --> M1["mas-terminos"]
    D --> D1["coef-ent"]
    D --> D2["expo-nat"]
    D1 --> D3["n = 4"]
    D2 --> D4["k = 5"]
    M1 --> E["termino"]
    M1 --> M2["mas-terminos"]
    E --> E1["coef-rac"]
    E --> E2["expo-nat"]
    E1 --> E3["num = -3"]
    E1 --> E4["den = 2"]
    E2 --> E5["k = 2"]
    M2 --> F["termino"]
    M2 --> S["sin-terminos"]
    F --> F1["coef-ent"]
    F --> F2["expo-nat"]
    F1 --> F3["n = 7"]
    F2 --> F4["k = 0"]
```

**Lectura:** hay tres `mas-terminos` encadenados y, al final, `sin-terminos`. El último término, $7x^0$, es el término independiente: tiene `expo-nat` con `k = 0`. Los exponentes bajan $5 > 2 > 0$, como exige el invariante.

---

## 4. Resultado de `(sumar p q)`

Polinomios del ejemplo de la Parte 3 del taller:

- $p(x) = 4x^5 - \tfrac{3}{2}x^2 + 7$ (su árbol es el del caso 3).
- $q(x) = -4x^5 + \tfrac{1}{2}x^2 + 2x$.
- $p + q = -x^2 + 2x + 7$.

### 4.1 Árbol de $q$

```mermaid
graph TD
    A["poli"] --> B["nombre-var"]
    A --> C["mas-terminos"]
    B --> B1["s = x"]
    C --> D["termino"]
    C --> M1["mas-terminos"]
    D --> D1["coef-ent"]
    D --> D2["expo-nat"]
    D1 --> D3["n = -4"]
    D2 --> D4["k = 5"]
    M1 --> E["termino"]
    M1 --> M2["mas-terminos"]
    E --> E1["coef-rac"]
    E --> E2["expo-nat"]
    E1 --> E3["num = 1"]
    E1 --> E4["den = 2"]
    E2 --> E5["k = 2"]
    M2 --> F["termino"]
    M2 --> S["sin-terminos"]
    F --> F1["coef-ent"]
    F --> F2["expo-nat"]
    F1 --> F3["n = 2"]
    F2 --> F4["k = 1"]
```

### 4.2 Árbol del resultado $p + q$

```mermaid
graph TD
    A["poli"] --> B["nombre-var"]
    A --> C["mas-terminos"]
    B --> B1["s = x"]
    C --> D["termino"]
    C --> M1["mas-terminos"]
    D --> D1["coef-ent"]
    D --> D2["expo-nat"]
    D1 --> D3["n = -1"]
    D2 --> D4["k = 2"]
    M1 --> E["termino"]
    M1 --> M2["mas-terminos"]
    E --> E1["coef-ent"]
    E --> E2["expo-nat"]
    E1 --> E3["n = 2"]
    E2 --> E4["k = 1"]
    M2 --> F["termino"]
    M2 --> S["sin-terminos"]
    F --> F1["coef-ent"]
    F --> F2["expo-nat"]
    F1 --> F3["n = 7"]
    F2 --> F4["k = 0"]
```

### 4.3 Origen de cada nodo del resultado

`sumar` recorre las dos listas en paralelo, una sola vez, comparando los exponentes de las cabezas. El siguiente diagrama muestra de qué operando viene cada término del resultado:

```mermaid
graph LR
    subgraph P["Operando p"]
        P5["termino: 4, x^5"]
        P2["termino: -3/2, x^2"]
        P0["termino: 7, x^0"]
    end
    subgraph Q["Operando q"]
        Q5["termino: -4, x^5"]
        Q2["termino: 1/2, x^2"]
        Q1["termino: 2, x^1"]
    end
    subgraph R["Resultado p + q"]
        R2["termino: -1, x^2"]
        R1["termino: 2, x^1"]
        R0["termino: 7, x^0"]
    end
    X5["CANCELADO: 4 + (-4) = 0"]
    P5 --> X5
    Q5 --> X5
    P2 -->|"-3/2 + 1/2 = -1"| R2
    Q2 -->|"-3/2 + 1/2 = -1"| R2
    Q1 -->|"se copia"| R1
    P0 -->|"se copia"| R0
```

| Nodo del resultado | Origen | Explicación |
|---|---|---|
| `nombre-var` con `s = x` | Ambos | Se verifica que $p$ y $q$ estén en la misma variable y se conserva la de $p$. |
| `termino` de $x^2$, `coef-ent -1` | **Ambos** ($p$ y $q$) | Exponentes iguales: $-\tfrac{3}{2} + \tfrac{1}{2} = -1$. La suma es un entero, así que el resultado es `coef-ent`, no `coef-rac`. |
| `termino` de $x^1$, `coef-ent 2` | Solo $q$ | $p$ no tiene $x^1$, así que el término de $q$ se copia sin cambios. |
| `termino` de $x^0$, `coef-ent 7` | Solo $p$ | $q$ no tiene término independiente, así que el de $p$ se copia sin cambios. |
| Términos de $x^5$ | **Se cancelaron** | $4 + (-4) = 0$, así que no aparece ningún nodo en el resultado. |

### 4.4 Traza de `sumar-terminos`

| Paso | Cabeza de $p$ | Cabeza de $q$ | Comparación | Acción |
|---|---|---|---|---|
| 1 | $(4,5)$ | $(-4,5)$ | $5 = 5$ | Suma $0$: el término desaparece. Se avanza en ambas listas. |
| 2 | $(-\tfrac{3}{2},2)$ | $(\tfrac{1}{2},2)$ | $2 = 2$ | Suma $-1$: se emite $(-1,2)$. Se avanza en ambas. |
| 3 | $(7,0)$ | $(2,1)$ | $0 < 1$ | Gana $q$: se emite $(2,1)$ y se avanza solo en $q$. |
| 4 | $(7,0)$ | lista vacía | — | Se retorna lo que queda de $p$: $(7,0)$. |

Resultado: $(-1,2),\,(2,1),\,(7,0)$. Los exponentes siguen en orden estrictamente decreciente, y cada lista se recorrió una sola vez.
