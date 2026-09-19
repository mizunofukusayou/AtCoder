---
title: "AtCoderの成長記録"
emoji: "🐡"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [AtCoder]
published: true
---

# ABC

## 455

- 多重ループを回すときに、`rep(i, n) rep(j, m)`のように書くと、インデントが浅くなって、コードが見やすくなる。
- `reduce`を使うと配列の総和や累積を簡単に求めることができる。
  - `reduce(all(v), 0LL)`で、long long型で配列vの総和を求めることができる。
- `[](int acc, int i){return acc * i;}`でラムダ式を定義できる。

## 453

- stringに対して、`substr(pos, len)`とすることで、posからlen文字分の部分文字列を取得できる。

## 450

- CTADにより、vectorの中身を推論してくれるので、`vector v(n, vector<int>(m));`のように書くことができる。

## 446

- `'a'-'A'=32`であるから、`char c = 'A'; c^=32;`(XOR)とすることで、cを小文字に変換できる。
- `char c = 'a'; c &= ~32;`とすることで、cを大文字に変換できる。
- `auto exist = std::views::iota(1, m + 1) | std::ranges::to<std::set<int>>();`とすることで、1からmまでの整数を要素とするsetを作ることができる。

## 457

- 2次元配列について、それぞれの行の要素数は異なってよく、`a[i].resize(m);`とすることで、行iの要素数をmに変更できる。
- 判別問題の方が早く解けることが多い。
- `ranges::partition_point`を使うときに、`0LL`とすることを忘れないようにする。
  - `ranges::partition_point(views::iota(0LL, INF), [](ll x) -> bool { ... return x > k })`
- コーナーケースでのWAが出た時は、`INF`が間違っている可能性を考慮する。
- 切り上げの計算は`(a + b - 1) / b`でできる。

## 442

- boolの反転は、`b ^= 1;`,`b = !b;`

## 458

- intの最大値は大体2*10^9
- priority_queueで任意の場所から値を取得するのは難しいが、二つに分割することで取得できるようになる。(移動させる時には、`pq1.push(pq.top()), pq2.pop();`のように)

## 434

- `cout << fixed << setprecision(12) << a << '\n';`で桁数を設定して出力

## 451

- `multiset`型は要素自身がキーとなるsetで、重複あり。

## 450

- 関数に対して、ポインタ渡しではなく参照渡しにすると安全&簡潔
- `int dx[] = {0, 1, 0, -1}, dy[] = {1, 0, -1, 0};`を使うと隣接マスへの移動に便利
- ラムダ式で`[&]`とすると環境の変数への参照をもてる
- ラムダ式で自身へのポインタを持つと再帰関数を作れる`auto f = [](auto f) {f(f);};`

## 463

- 昇順の配列に対して`upper_bound`を使うと二分探索してくれる

### `range::sort()`

- **イテレータの省略**: `std::sort(cloth.begin(), cloth.end())` と書く代わりに、コンテナを直接 `ranges::sort(cloth)` と渡せます。
- **プロジェクション（射影）の指定**:

```cpp
ranges::sort(cloth, {}, [](const auto& p){ return p.second; });

```

第2引数 `{}`（デフォルトの比較演算子 `<`）と第3引数のラムダ式を組み合わせることで、「どの値を取り出して比較するか」を直接指定できます。

- `std::sort` で書く場合:

```cpp
std::sort(cloth.begin(), cloth.end(), [](const auto& a, const auto& b) {
    return a.second < b.second;
});

```

`ranges::sort` のプロジェクション機能を使うと、`<` の比較自体を書く必要がなく、`return p.second;` と取り出すキーを指定するだけで昇順ソートが可能です。

### `ranges::partition_point` による二分探索の仕組み**

普段書いている `while (ng - ok > 1)` のループ処理を、標準ライブラリが一括して行っています。

普段書く二分探索の形と比較すると以下の通りです：

```cpp
// 従来の書き方
int ok = 0, ng = 1000000000;
auto check = [&](int x) { ... return chosen >= K; };

while (ng - ok > 1) {
    int mid = ok + (ng - ok) / 2;
    if (check(mid)) ok = mid;
    else ng = mid;
}
// 最終的に ok が「条件を満たす最大値」、ng が「最初に条件を満たさなくなる値」

```

```cpp
auto check = [&](int x) { ... return chosen >= K; };

// 探索範囲 [0, 1000000000) を指定して二分探索
int ng = *ranges::partition_point(views::iota(0, 1000000000), check);
int ok = ng - 1; // 条件を満たす最大値
```

**対応関係と動作の仕組み**

- `views::iota(0, 1000000000)` が探索する整数列 $0, 1, 2, \dots, 999999999$ を表します。
- `partition_point` は、`check(x)` が **`true` から `false` に切り替わる境界の要素（最初に `false` となる値）** のイテレータを返します。
- したがって、`*ranges::partition_point(...)` の結果は、従来のコードの **`ng` と完全に一致** します。
- 「条件を満たす最大値（`ok`）」が必要な場合は、得られた値から `- 1` を引くだけで取得できます。

## 470

- `" \n"[i == n]`とするとこで、iがnのときに改行、それ以外のときに空白を出力できる。
  - `for (int i = 0; i < n; i++) cout << p[i] + 1 << " \n"[i + 1 == n];`

## 472

- `mdspan`を使用することで、`vector[i*h+j]`へのアクセスを簡単に記述できるようになる。
  - あくまで`mdspan`はアクセスを簡単に記述するためであり、データ構造は`vector, array`を用いて用意する。(C++26の`mdarray`で変わるかも)

## $L_\infty, L_1$

$L_\infty$ : $\max(|x|, |y|)$
$L_1$ : $|x| + |y|$

$$
\begin{cases}
  X = x + y \\
  Y = -x + y
\end{cases}
$$

の変換をすることで（ $-\pi/4$ 回転）、問題を単純にできることがある。

$L_\infty \to L_1$ : 各軸を独立に分解する
$L_1 \to L_\infty$ : 領域を軸に並行な長方形にする。

### 重み付き計算($L_1$)

$$
\begin{aligned}
  F(x)
  &= \sum_k a_k |k - x| \\
  &= \sum_{k < x} a_k(x - k)
  + \sum_{k > x} a_k(k - x) \\
  &= 2\left(
  x\sum_{k < x}a_k
  -\sum_{k < x}k a_k
  \right)
  +\sum_k k a_k
  -x\sum_k a_k
\end{aligned}
$$

ここで、累積和を

$$
S_n=\sum_{k < n} a_k \qquad T=\sum_{k < n} k a_k
$$

とすると、

$$
F(x) = 2 (x S_x - T_x) + T_n - x S_n
$$

こうすることで、$O(1)$ で処理できる。

## live_library

- `using P = pair<int, int>`を前提とすることがある。

## 461

- if文を使う代わりに、`bool`をそのまま四則演算に用いるようにすると、最適化を維持しやすい。
  - `if(a == 2) ++ans;`よりも`ans += (a == 2)`
  - `if(a == 2 && b == 3) ++ ans;`よりも`ans += (a == 2) & (b == 3)`

## 452

- `std::accumulate` の改善版として `ranges::fold_left` がある。
  - [使用例](https://atcoder.jp/contests/abc452/editorial/18360)
