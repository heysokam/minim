static u32 args01 (i32 const one, i32 const two) { return 0; }
static u32 args02 (i32* const one, i32* const two) { return 0; }
static u32 args03 (i32 const* const one, i32 const* const two) { return 0; }
static u32 args04 (u32 const one[1], u32 const two[1]) { return 0; }
static u32 args05 (u32* const one[2], u32* const two[2]) { return 0; }
static u32 args06 (u32 const* const one[3], u32 const* const two[3]) { return 0; }
static u32 args07 (u32 const one[], u32 const two[]) { return 0; }
static u32 args08 (u32* const one[], u32* const two[]) { return 0; }
static u32 args09 (u32 const* const one[], u32 const* const two[]) { return 0; }
static u32 args01_mut (i32 one, i32 two) { return 0; }
static u32 args02_mut (i32* one, i32* two) { return 0; }
static u32 args03_mut (i32 const* one, i32 const* two) { return 0; }
static u32 args04_mut (u32 one[1], u32 two[1]) { return 0; }
static u32 args05_mut (u32* one[2], u32* two[2]) { return 0; }
static u32 args06_mut (u32 const* one[3], u32 const* two[3]) { return 0; }
static u32 args07_mut (u32 one[], u32 two[]) { return 0; }
static u32 args08_mut (u32* one[], u32* two[]) { return 0; }
static u32 args09_mut (u32 const* one[], u32 const* two[]) { return 0; }
static u32 rett01 (void) { return 0; }
static u32* rett02 (void) { return 0; }
static u32 const* rett03 (void) { return 0; }
static u32 rett01_mut (void) { return 0; }
static u32* rett02_mut (void) { return 0; }
static u32 const* rett03_mut (void) { return 0; }
static u32 args_multiline1 (i32 const one, i32 two, i32* thr) { return 0; }
static u32 args_multiline2 (u64* const one, i32 const* const two) { return 0; }
static u32 args_multiline3 (i32 const arg00[1], i32 const* const arg01[1], i32 const arg02[], i32* const arg03[], i32 const* const arg04[], i32 const* arg05[4], i32 const* arg06[SomeSymbol], i32 const* arg07[]) { return 0; }
i32 protoFn (i32 const arg0);
inline static u32 const* inlineFn (void) { return 0; }
unsigned long long* multiword (signed char* const one) { return 0; }
static signed long long int const* cursed (signed char const* one[SomeSymbol], unsigned long long const* two[]);
