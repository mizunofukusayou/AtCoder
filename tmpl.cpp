// clang-format off
#include <bits/stdc++.h>
using namespace std;
// #include <atcoder/all>
// using namespace atcoder;

using ll = long long;
using pll = pair<ll, ll>;
template<typename T> using vc = vector<T>;
using vl = vc<ll>;
using mll = map<ll, ll>;

#define all(v) v.begin(), v.end()
#define rall(v) v.rbegin(), v.rend()
#define sz(x) (ll)(x).size()

const ll INF = 1LL << 60;

#define OVERLOAD_REP(a, b, c, d, name, ...) name
#define rep(...) OVERLOAD_REP(__VA_ARGS__, REP3, REP2, REP1, REP0)(__VA_ARGS__)
#define REP0(x) for (ll _rep_counter = 0; _rep_counter < (x); ++_rep_counter)
#define REP1(i, x) for (ll i = 0; (i) < (x); ++(i))
#define REP2(i, l, r) for (ll i = (l); (i) < (r); ++(i))
#define REP3(i, l, r, c) for (ll i = (l); ((c) > 0 ? (i) < (r) : (i) > (r)); i += (c))

template <typename... Args> void in(Args &...args) { (std::cin >> ... >> args); }
#define LL(...) ll __VA_ARGS__; in(__VA_ARGS__)
#define STR(...) string __VA_ARGS__; in(__VA_ARGS__)
#define VEC(type, name, size) vc<type> name(size); for (auto &x_ : name) in(x_)
#define VL(name, size) VEC(ll, name, size)

template<typename T> bool chmin(T& a, T b){if(a > b){a = b; return true;} return false;}
template<typename T> bool chmax(T& a, T b){if(a < b){a = b; return true;} return false;}

template <class... Args>
void co(Args&&... args) {
    int i = 0;
    ((cout << (i++ ? " " : "") << args), ...) << '\n';
}

template<typename T> void print_vec(const vector<T> &v, bool split_line=false) {
    for (int i = 0; i < (int)v.size(); i++) cout << v[i] << " \n"[split_line || i+1==(int)v.size()];
}
// clang-format on

void solve() {}

int main() {
  cin.tie(nullptr);
  ios_base::sync_with_stdio(false);
  int t = 1;
  // cin >> t;
  while (t--)
    solve();
}
