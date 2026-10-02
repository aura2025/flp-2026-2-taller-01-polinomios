# Informe de corrección — Taller 1: Un TAD con tres caras

**Autores:** Valentina Valencia Lopez (2459626), Aura Maria Pelaez Luna (2459422)

## 0. Notación y convenciones

Un polinomio es $p = (v, T)$, con $v$ el nombre de la variable y $T$ la lista de términos. La lista de términos se define por la gramática:

$$T ::= [\,] \;\mid\; t :: T'$$

donde cada término es $t = (c, e)$ con coeficiente $c \in \mathbb{Q}$ y exponente $e \in \mathbb{N}$. Escribimos:

- $|T|$: longitud de la lista.
- $\mathrm{exps}(T)$: conjunto de exponentes de $T$.
- $\mathrm{terms}(T)$: conjunto de términos de $T$.
- $e_0, c_0$: exponente y coeficiente del primer término cuando $T = (c_0, e_0) :: T'$.

### Invariante de la representación

$$\mathrm{Inv}(T) \iff \mathrm{Ord}(T) \wedge \mathrm{NoCero}(T) \wedge \mathrm{Nat}(T) \wedge \mathrm{Red}(T)$$

1. **Ord(T):** los exponentes son estrictamente decrecientes. Formalmente, $T = [\,]$, o $T = (c_0,e_0)::T'$ con $\forall e' \in \mathrm{exps}(T'),\; e_0 > e'$ y $\mathrm{Ord}(T')$.
2. **NoCero(T):** $\forall (c,e) \in T,\; c \neq 0$.
3. **Nat(T):** $\forall (c,e) \in T,\; e \in \mathbb{Z}$ y $e \ge 0$.
4. **Red(T):** todo coeficiente racional $a/b$ cumple $b > 0$ y $\gcd(|a|, b) = 1$.

$\mathrm{Inv}(p)$ significa $\mathrm{Inv}(T)$ para la lista de términos de $p$.

### Lemas de apoyo

**Lema 1 (las colas heredan el invariante).** Si $\mathrm{Inv}((c_0,e_0)::T')$, entonces $\mathrm{Inv}(T')$. Las cuatro condiciones son universales sobre los términos, y $T'$ tiene un subconjunto de esos términos.

**Lema 2 (cota del primer término).** Si $\mathrm{Inv}((c_0,e_0)::T')$, entonces $\forall e' \in \mathrm{exps}(T'),\; e' < e_0$. Es la definición de $\mathrm{Ord}$.

**Lema 3 (aritmética exacta).** Sean $x, y$ racionales exactos de Racket. Entonces $x + y$ es un racional exacto. Además, `numerator` y `denominator` de un racional exacto de Racket devuelven $a, b$ con $b > 0$ y $\gcd(|a|,b)=1$. Por eso todo coeficiente construido con `(coef-ent n)` o `(coef-rac (numerator x) (denominator x))` cumple $\mathrm{Red}$.

**Decodificación de coeficientes.** En las funciones, `(coef-ent n)` se decodifica como $n$ y `(coef-rac num den)` como $num/den$. Esa decodificación es la inversa de la codificación del Lema 3, así que el coeficiente concreto que entra es el mismo que sale.

---

## 1. Corrección de `coeficiente-de`

### Especificación

- **Pre-condición:** $\mathrm{Inv}(p)$ con $p = (v,T)$, y $e$ es un entero con $e \ge 0$. (Si $e$ no es entero o es negativo, las guardas iniciales levantan error antes de recorrer la lista.)
- **Post-condición:**
  - Si $\exists c.\;(c,e) \in \mathrm{terms}(T)$, el resultado es ese $c$.
  - Si $e \notin \mathrm{exps}(T)$, la función levanta error.

### Demostración por inducción estructural sobre $T$

Se demuestra $P(T)$: «para todo $e \in \mathbb{N}$ y todo $T$ con $\mathrm{Inv}(T)$, la función cumple la post-condición».

**Caso base, $T = [\,]$.** No existe ningún término, luego $e \notin \mathrm{exps}([\,])$. La función cae en la rama `sin-terminos` y levanta el error «No hay términos para consultar su coeficiente». La post-condición se cumple.

**Paso inductivo, $T = (c_0,e_0) :: T'$.** Se asume $P(T')$ como hipótesis de inducción (HI), aplicable por el Lema 1. Se comparan $e$ y $e_0$, y hay tres casos exhaustivos y excluyentes:

- **Caso A, $e = e_0$.** El término $(c_0,e_0)$ tiene el exponente buscado y la función retorna $c_0$ decodificado. Por $\mathrm{Ord}$ no hay otro término con el mismo exponente, así que $c_0$ es el único coeficiente posible. Se cumple la post-condición.
- **Caso B, $e < e_0$.** Como $e \ne e_0$, se cumple $e \in \mathrm{exps}(T) \iff e \in \mathrm{exps}(T')$. La función llama a `coeficiente-de` sobre $(v,T')$ con el mismo $e$. Por la HI, si $e \in \mathrm{exps}(T')$ devuelve su coeficiente, que es el de $T$. Si $e \notin \mathrm{exps}(T')$, levanta error, y en ese caso $e \notin \mathrm{exps}(T)$. Se cumple la post-condición.
- **Caso C, $e > e_0$.** Por el Lema 2, todo $e' \in \mathrm{exps}(T')$ cumple $e' < e_0 < e$. Luego $e \notin \mathrm{exps}(T)$, y la función levanta el error «El polinomio no tiene término con ese exponente». Se cumple la post-condición. Este caso es la razón por la que no hace falta recorrer toda la lista: el orden garantiza que el exponente ya no puede aparecer.

Por inducción estructural, $P(T)$ vale para toda lista $T$ con $\mathrm{Inv}(T)$. $\blacksquare$

### Terminación

Medida: $\mu(T) = |T| \in \mathbb{N}$.

- La única llamada recursiva (Caso B) se hace sobre $T'$, con $\mu(T') = \mu(T) - 1 < \mu(T)$.
- Los casos base, $T=[\,]$ (error), A (retorno) y C (error), no hacen llamadas recursivas.

Como $\mathbb{N}$ es bien fundado, no existe una cadena infinita decreciente y la función termina. Además, en cada llamada se examina un solo término, así que la lista se recorre a lo sumo una vez: $O(|T|)$.

---

## 2. Corrección de `eliminar-termino`

### Especificación

- **Pre-condición:** $\mathrm{Inv}(p)$ con $p = (v,T)$, y $e$ es un entero con $e \ge 0$.
- **Post-condición:**
  - Si $e \in \mathrm{exps}(T)$, el resultado es $(v,R)$ con $\mathrm{terms}(R) = \mathrm{terms}(T) \setminus \{(c,e)\}$, donde $(c,e)$ es el único término de $T$ con exponente $e$. Además $R$ conserva el orden relativo de $T$ y $\mathrm{Inv}(R)$.
  - Si $e \notin \mathrm{exps}(T)$, la función levanta error.

### Demostración por inducción estructural sobre $T$

**Caso base, $T = [\,]$.** No hay término con exponente $e$. La función levanta el error «No hay términos para eliminar». Se cumple la post-condición.

**Paso inductivo, $T = (c_0,e_0) :: T'$.** HI: la post-condición vale para $T'$ (es válida por el Lema 1).

- **Caso A, $e = e_0$.** La función retorna $(v,T')$. Por $\mathrm{Ord}$ el término $(c_0,e_0)$ es el único con exponente $e$, y por tanto $\mathrm{terms}(T') = \mathrm{terms}(T) \setminus \{(c_0,e_0)\}$. El orden de $T'$ es el de $T$ sin su primer elemento, y $\mathrm{Inv}(T')$ vale por el Lema 1.
- **Caso B, $e < e_0$.** Como $e \neq e_0$, $e \in \mathrm{exps}(T) \iff e \in \mathrm{exps}(T')$.
  - *Si $e \in \mathrm{exps}(T')$:* por la HI la llamada recursiva retorna $(v,R')$ con $\mathrm{terms}(R') = \mathrm{terms}(T') \setminus \{(c,e)\}$ y $\mathrm{Inv}(R')$. La función retorna $(v, (c_0,e_0) :: R')$, y:
    - **Contenido:** $\mathrm{terms}((c_0,e_0)::R') = \{(c_0,e_0)\} \cup (\mathrm{terms}(T') \setminus \{(c,e)\}) = \mathrm{terms}(T) \setminus \{(c,e)\}$. Esto vale porque $(c_0,e_0) \neq (c,e)$ ya que $e_0 \neq e$.
    - **Orden:** $\mathrm{exps}(R') \subseteq \mathrm{exps}(T')$, y por el Lema 2 todos son menores que $e_0$. Con $\mathrm{Ord}(R')$ se obtiene $\mathrm{Ord}((c_0,e_0)::R')$.
    - **Resto del invariante:** NoCero, Nat y Red se cumplen porque los términos son un subconjunto de los de $T$.
  - *Si $e \notin \mathrm{exps}(T')$:* por la HI la llamada recursiva levanta error, y ese error se propaga. Es correcto, porque entonces $e \notin \mathrm{exps}(T)$.
- **Caso C, $e > e_0$.** Igual que en el Caso C de la sección 1: $e \notin \mathrm{exps}(T)$ y la función levanta el error «El polinomio no tiene término con ese exponente».

Por inducción estructural la post-condición vale para toda $T$ con $\mathrm{Inv}(T)$. $\blacksquare$

### Terminación

Medida $\mu(T) = |T|$. La única llamada recursiva (Caso B) es sobre $T'$, con $\mu(T') = \mu(T) - 1$. Los demás casos no recursivan, así que la función termina. Se examina un término por llamada, por lo que la lista se recorre a lo sumo una vez.

---

## 3. `insertar-termino` preserva el invariante

### Especificación

- **Pre-condición:** $\mathrm{Inv}(p)$ con $p=(v,T)$, $e \in \mathbb{N}$ y $c$ un racional exacto.
- **Post-condición:** $\mathrm{Inv}(p')$ con $p' = \texttt{insertar-termino}(p,c,e)$. Además:
  - Si $e \notin \mathrm{exps}(T)$ y $c \ne 0$, el resultado añade $(c,e)$ a $T$.
  - Si $e = e_k \in \mathrm{exps}(T)$ con coeficiente $c_k$, el término $(c_k, e_k)$ pasa a $(c_k + c, e_k)$, o desaparece si $c_k + c = 0$.

### Caso previo: $c = 0$

La función retorna $p$ sin cambios (guarda explícita), y $\mathrm{Inv}(p)$ se cumple por hipótesis. De aquí en adelante, $c \neq 0$. Las guardas de error (exponente no entero, negativo o coeficiente inexacto) no retornan ningún polinomio, así que no pueden violar el invariante.

### Lema auxiliar (sobre la lista de términos)

Sea $R = \mathrm{ins}(T,c,e)$ la lista resultante. Se demuestra por inducción sobre $|T|$ la afirmación reforzada:

$$Q(T):\quad \mathrm{Inv}(T) \Rightarrow \mathrm{Inv}(R) \;\wedge\; \mathrm{exps}(R) \subseteq \mathrm{exps}(T) \cup \{e\}$$

**Caso base, $T = [\,]$ (exponente nuevo).** $R = [(c,e)]$.

- Ord: hay un solo término, así que se cumple trivialmente.
- NoCero: $c \neq 0$.
- Nat: $e \in \mathbb{N}$ por la pre-condición.
- Red: $c$ se construye como `(coef-ent c)` si es entero, o `(coef-rac (numerator c) (denominator c))` si no, y por el Lema 3 está reducido.
- $\mathrm{exps}(R) = \{e\}$, luego se cumple la segunda parte.

**Paso inductivo, $T = (c_0,e_0)::T'$.** HI: $Q(T')$. Hay cuatro casos:

- **Caso 1: exponente nuevo, $e > e_0$.** $R = (c,e) :: T$.
  - Ord: por $\mathrm{Ord}(T)$ y $e > e_0 > e'$ para todo $e' \in \mathrm{exps}(T')$, el nuevo primer término tiene exponente mayor que todos los demás.
  - NoCero: $c \ne 0$ y los demás términos no cambian.
  - Nat, Red: igual que en el caso base para el término nuevo. Los demás no cambian.
  - $\mathrm{exps}(R) = \mathrm{exps}(T) \cup \{e\}$.
- **Caso 2: exponente ya existía y la suma no es cero, $e = e_0$ y $s = c_0 + c \neq 0$.** $R = (s,e_0) :: T'$.
  - Ord: el exponente del primer término no cambia, así que sigue siendo mayor que todos los de $T'$ (Lema 2). $\mathrm{Ord}(T')$ vale por el Lema 1.
  - NoCero: $s \neq 0$ por la condición del caso.
  - Red: $s$ es un racional exacto (Lema 3) y se reconstruye con `numerator` y `denominator`, así que queda reducido.
  - Nat: $e_0$ no cambia.
  - $\mathrm{exps}(R) = \mathrm{exps}(T)$.
- **Caso 3: exponente ya existía y la suma es cero, $e = e_0$ y $c_0 + c = 0$.** $R = T'$. Por el Lema 1, $\mathrm{Inv}(T')$ vale. Además, $\mathrm{exps}(R) \subseteq \mathrm{exps}(T)$.
- **Caso 4: $e < e_0$ (se sigue buscando).** $R = (c_0,e_0) :: R'$ con $R' = \mathrm{ins}(T',c,e)$. Por el Lema 1, la HI es aplicable:
  - Por la HI, $\mathrm{Inv}(R')$ y $\mathrm{exps}(R') \subseteq \mathrm{exps}(T') \cup \{e\}$.
  - Ord: los elementos de $\mathrm{exps}(T')$ son menores que $e_0$ (Lema 2) y además $e < e_0$ (condición del caso). Por tanto, todos los elementos de $\mathrm{exps}(R')$ son menores que $e_0$. Con $\mathrm{Ord}(R')$ se obtiene $\mathrm{Ord}(R)$.
  - NoCero, Nat, Red: el término $(c_0,e_0)$ ya los cumplía, y $R'$ los cumple por la HI.
  - $\mathrm{exps}(R) \subseteq \mathrm{exps}(T) \cup \{e\}$.

Los cuatro casos cubren todas las posibilidades al comparar $e$ con $e_0$. Los tres casos que pide el taller (exponente nuevo, exponente existente con suma no nula, exponente existente con suma nula) corresponden a los Casos 1 (y al caso base), 2 y 3. El Caso 4 solo desciende por la lista hasta llegar a uno de ellos. $\blacksquare$

### Terminación

Medida $|T|$. La llamada recursiva del Caso 4 es sobre $T'$ con $|T'| = |T| - 1$. Los demás casos no recursivan. La lista se recorre una sola vez y no se ordena al final, porque el término se coloca en su posición correcta al encontrarla.

### Representación con datatypes

En `polinomios-datatypes.rkt`, `insertar-termino` construye el polinomio de un solo término $(v,[(c,e)])$ y lo combina con `sumar`. Ese polinomio cumple $\mathrm{Inv}$ (mismo argumento del caso base). Por tanto, el resultado preserva el invariante si `sumar` lo preserva, como se muestra a continuación.

**`sumar` preserva el invariante.** Sean $\mathrm{Inv}(T_P)$ y $\mathrm{Inv}(T_Q)$. Se demuestra por inducción sobre $|T_P| + |T_Q|$ que el resultado $S$ cumple $\mathrm{Inv}(S)$ y $\mathrm{exps}(S) \subseteq \mathrm{exps}(T_P) \cup \mathrm{exps}(T_Q)$:

- Si alguna de las dos listas es vacía, se retorna la otra, que cumple $\mathrm{Inv}$.
- Si $k_P > k_Q$, se retorna $t_P :: \mathrm{sumar}(R_P, T_Q)$. Los exponentes de $R_P$ son menores que $k_P$ (Lema 2) y los de $T_Q$ son $\le k_Q < k_P$. Por eso el primer término sigue siendo mayor que todos los del resto.
- Si $k_P < k_Q$, el argumento es simétrico.
- Si $k_P = k_Q$ y la suma de coeficientes es distinta de cero, se retorna un término con ese exponente y esa suma, seguido de la suma de las colas. Las colas tienen exponentes menores que $k_P$, y el coeficiente queda reducido por el Lema 3.
- Si $k_P = k_Q$ y la suma es cero, el término desaparece y se retorna la suma de las colas, que cumple $\mathrm{Inv}$ por la HI.

En todos los casos la medida $|T_P|+|T_Q|$ decrece estrictamente (en uno o en dos), así que termina. $\blacksquare$

---

## 4. Equivalencia de las representaciones con listas y con procedimientos

### Por qué las funciones son las mismas

Las funciones `polinomio-cero`, `insertar-termino`, `coeficiente-de` y `eliminar-termino` están escritas exclusivamente en términos de la **interfaz** del TAD:

- **Constructores:** `poli`, `nombre-var`, `sin-terminos`, `mas-terminos`, `termino`, `coef-ent`, `coef-rac`, `expo-nat`.
- **Predicados:** `sin-terminos?`, `coef-ent?`, etc.
- **Extractores:** `poli->var`, `poli->terms`, `mas-terminos->term`, `mas-terminos->resto`, `termino->coef`, `termino->expo`, `coef-ent->n`, `coef-rac->num`, `coef-rac->den`, `expo-nat->k`.

Ninguna de ellas usa `car`, `cdr` ni aplica un dato como procedimiento: nunca inspeccionan cómo está construido un dato. Por eso el texto de las cuatro funciones es idéntico en `polinomios-listas.rkt` y en `polinomios-procedimientos.rkt`. Solo cambian las definiciones de los constructores y observadores.

### Qué propiedad hace que el cliente no pueda distinguirlas

Es la propiedad de **independencia de la representación** (sección 2.2 de EOPL). Las dos representaciones cumplen las mismas ecuaciones de la especificación, por ejemplo:

$$\texttt{poli->var}(\texttt{poli}(v,t)) = v \qquad \texttt{mas-terminos->resto}(\texttt{mas-terminos}(t,r)) = r$$

$$\texttt{sin-terminos?}(\texttt{sin-terminos}()) = \texttt{\#t}$$

En las listas, `(poli v t)` es `(list 'poli v t)` y los extractores son `cadr` y `caddr`. En los procedimientos, `(poli v t)` es una clausura que responde a los mensajes `'var` y `'terms`. Para cada dato hay una correspondencia entre ambos valores, y todos los observadores devuelven el mismo resultado sobre datos correspondientes. Un programa cliente que solo usa la interfaz solo puede observar lo que dicen esas ecuaciones, por lo que produce los mismos resultados en una u otra representación, y no puede saber cuál está usando.

Hay una única excepción: lo que imprime el intérprete al mostrar un dato (una lista en un caso, un procedimiento opaco en el otro). Esa salida no forma parte de la interfaz, y es justamente el «secreto» que el TAD oculta. Este es el sentido del lema del taller: *«la representación es un secreto que el cliente no necesita»*.

### Relación con la representación con datatypes

La tercera representación usa `define-datatype` y `cases` en lugar de predicados y extractores, por lo que el texto de sus funciones es distinto. La especificación, el invariante y las demostraciones de las secciones 1 a 3 siguen siendo válidos, porque solo dependen de la estructura recursiva definida por la gramática y no de cómo se almacena.

---

## 5. Conclusión

- `coeficiente-de` y `eliminar-termino` son correctos respecto a su especificación y terminan, con la medida $|T|$ como función decreciente.
- `insertar-termino` preserva el invariante $\mathrm{Inv}$ en los tres casos (exponente nuevo, suma no nula, suma nula). En la versión con datatypes esto se apoya en que `sumar` también lo preserva.
- Las versiones con listas y con procedimientos son intercambiables para el cliente porque las funciones solo usan la interfaz.an consultado.}}
