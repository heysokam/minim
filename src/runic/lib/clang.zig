pub const __builtin_bswap16 = @import("std").zig.c_builtins.__builtin_bswap16;
pub const __builtin_bswap32 = @import("std").zig.c_builtins.__builtin_bswap32;
pub const __builtin_bswap64 = @import("std").zig.c_builtins.__builtin_bswap64;
pub const __builtin_signbit = @import("std").zig.c_builtins.__builtin_signbit;
pub const __builtin_signbitf = @import("std").zig.c_builtins.__builtin_signbitf;
pub const __builtin_popcount = @import("std").zig.c_builtins.__builtin_popcount;
pub const __builtin_ctz = @import("std").zig.c_builtins.__builtin_ctz;
pub const __builtin_clz = @import("std").zig.c_builtins.__builtin_clz;
pub const __builtin_sqrt = @import("std").zig.c_builtins.__builtin_sqrt;
pub const __builtin_sqrtf = @import("std").zig.c_builtins.__builtin_sqrtf;
pub const __builtin_sin = @import("std").zig.c_builtins.__builtin_sin;
pub const __builtin_sinf = @import("std").zig.c_builtins.__builtin_sinf;
pub const __builtin_cos = @import("std").zig.c_builtins.__builtin_cos;
pub const __builtin_cosf = @import("std").zig.c_builtins.__builtin_cosf;
pub const __builtin_exp = @import("std").zig.c_builtins.__builtin_exp;
pub const __builtin_expf = @import("std").zig.c_builtins.__builtin_expf;
pub const __builtin_exp2 = @import("std").zig.c_builtins.__builtin_exp2;
pub const __builtin_exp2f = @import("std").zig.c_builtins.__builtin_exp2f;
pub const __builtin_log = @import("std").zig.c_builtins.__builtin_log;
pub const __builtin_logf = @import("std").zig.c_builtins.__builtin_logf;
pub const __builtin_log2 = @import("std").zig.c_builtins.__builtin_log2;
pub const __builtin_log2f = @import("std").zig.c_builtins.__builtin_log2f;
pub const __builtin_log10 = @import("std").zig.c_builtins.__builtin_log10;
pub const __builtin_log10f = @import("std").zig.c_builtins.__builtin_log10f;
pub const __builtin_abs = @import("std").zig.c_builtins.__builtin_abs;
pub const __builtin_labs = @import("std").zig.c_builtins.__builtin_labs;
pub const __builtin_llabs = @import("std").zig.c_builtins.__builtin_llabs;
pub const __builtin_fabs = @import("std").zig.c_builtins.__builtin_fabs;
pub const __builtin_fabsf = @import("std").zig.c_builtins.__builtin_fabsf;
pub const __builtin_floor = @import("std").zig.c_builtins.__builtin_floor;
pub const __builtin_floorf = @import("std").zig.c_builtins.__builtin_floorf;
pub const __builtin_ceil = @import("std").zig.c_builtins.__builtin_ceil;
pub const __builtin_ceilf = @import("std").zig.c_builtins.__builtin_ceilf;
pub const __builtin_trunc = @import("std").zig.c_builtins.__builtin_trunc;
pub const __builtin_truncf = @import("std").zig.c_builtins.__builtin_truncf;
pub const __builtin_round = @import("std").zig.c_builtins.__builtin_round;
pub const __builtin_roundf = @import("std").zig.c_builtins.__builtin_roundf;
pub const __builtin_strlen = @import("std").zig.c_builtins.__builtin_strlen;
pub const __builtin_strcmp = @import("std").zig.c_builtins.__builtin_strcmp;
pub const __builtin_object_size = @import("std").zig.c_builtins.__builtin_object_size;
pub const __builtin___memset_chk = @import("std").zig.c_builtins.__builtin___memset_chk;
pub const __builtin_memset = @import("std").zig.c_builtins.__builtin_memset;
pub const __builtin___memcpy_chk = @import("std").zig.c_builtins.__builtin___memcpy_chk;
pub const __builtin_memcpy = @import("std").zig.c_builtins.__builtin_memcpy;
pub const __builtin_expect = @import("std").zig.c_builtins.__builtin_expect;
pub const __builtin_nanf = @import("std").zig.c_builtins.__builtin_nanf;
pub const __builtin_huge_valf = @import("std").zig.c_builtins.__builtin_huge_valf;
pub const __builtin_inff = @import("std").zig.c_builtins.__builtin_inff;
pub const __builtin_isnan = @import("std").zig.c_builtins.__builtin_isnan;
pub const __builtin_isinf = @import("std").zig.c_builtins.__builtin_isinf;
pub const __builtin_isinf_sign = @import("std").zig.c_builtins.__builtin_isinf_sign;
pub const __has_builtin = @import("std").zig.c_builtins.__has_builtin;
pub const __builtin_assume = @import("std").zig.c_builtins.__builtin_assume;
pub const __builtin_unreachable = @import("std").zig.c_builtins.__builtin_unreachable;
pub const __builtin_constant_p = @import("std").zig.c_builtins.__builtin_constant_p;
pub const __builtin_mul_overflow = @import("std").zig.c_builtins.__builtin_mul_overflow;
pub const CXError_Success: c_int = 0;
pub const CXError_Failure: c_int = 1;
pub const CXError_Crashed: c_int = 2;
pub const CXError_InvalidArguments: c_int = 3;
pub const CXError_ASTReadError: c_int = 4;
pub const enum_CXErrorCode = c_uint;
pub const CXString = extern struct {
    data: ?*const anyopaque = @import("std").mem.zeroes(?*const anyopaque),
    private_flags: c_uint = @import("std").mem.zeroes(c_uint),
};
pub const CXStringSet = extern struct {
    Strings: [*c]CXString = @import("std").mem.zeroes([*c]CXString),
    Count: c_uint = @import("std").mem.zeroes(c_uint),
};
pub extern fn clang_getCString(string: CXString) [*c]const u8;
pub extern fn clang_disposeString(string: CXString) void;
pub extern fn clang_disposeStringSet(set: [*c]CXStringSet) void;
pub extern fn clang_getBuildSessionTimestamp() c_ulonglong;
pub const struct_CXVirtualFileOverlayImpl = opaque {};
pub const CXVirtualFileOverlay = ?*struct_CXVirtualFileOverlayImpl;
pub extern fn clang_VirtualFileOverlay_create(options: c_uint) CXVirtualFileOverlay;
pub extern fn clang_VirtualFileOverlay_addFileMapping(CXVirtualFileOverlay, virtualPath: [*c]const u8, realPath: [*c]const u8) enum_CXErrorCode;
pub extern fn clang_VirtualFileOverlay_setCaseSensitivity(CXVirtualFileOverlay, caseSensitive: c_int) enum_CXErrorCode;
pub extern fn clang_VirtualFileOverlay_writeToBuffer(CXVirtualFileOverlay, options: c_uint, out_buffer_ptr: [*c][*c]u8, out_buffer_size: [*c]c_uint) enum_CXErrorCode;
pub extern fn clang_free(buffer: ?*anyopaque) void;
pub extern fn clang_VirtualFileOverlay_dispose(CXVirtualFileOverlay) void;
pub const struct_CXModuleMapDescriptorImpl = opaque {};
pub const CXModuleMapDescriptor = ?*struct_CXModuleMapDescriptorImpl;
pub extern fn clang_ModuleMapDescriptor_create(options: c_uint) CXModuleMapDescriptor;
pub extern fn clang_ModuleMapDescriptor_setFrameworkModuleName(CXModuleMapDescriptor, name: [*c]const u8) enum_CXErrorCode;
pub extern fn clang_ModuleMapDescriptor_setUmbrellaHeader(CXModuleMapDescriptor, name: [*c]const u8) enum_CXErrorCode;
pub extern fn clang_ModuleMapDescriptor_writeToBuffer(CXModuleMapDescriptor, options: c_uint, out_buffer_ptr: [*c][*c]u8, out_buffer_size: [*c]c_uint) enum_CXErrorCode;
pub extern fn clang_ModuleMapDescriptor_dispose(CXModuleMapDescriptor) void;
pub const __u_char = u8;
pub const __u_short = c_ushort;
pub const __u_int = c_uint;
pub const __u_long = c_ulong;
pub const __int8_t = i8;
pub const __uint8_t = u8;
pub const __int16_t = c_short;
pub const __uint16_t = c_ushort;
pub const __int32_t = c_int;
pub const __uint32_t = c_uint;
pub const __int64_t = c_long;
pub const __uint64_t = c_ulong;
pub const __int_least8_t = __int8_t;
pub const __uint_least8_t = __uint8_t;
pub const __int_least16_t = __int16_t;
pub const __uint_least16_t = __uint16_t;
pub const __int_least32_t = __int32_t;
pub const __uint_least32_t = __uint32_t;
pub const __int_least64_t = __int64_t;
pub const __uint_least64_t = __uint64_t;
pub const __quad_t = c_long;
pub const __u_quad_t = c_ulong;
pub const __intmax_t = c_long;
pub const __uintmax_t = c_ulong;
pub const __dev_t = c_ulong;
pub const __uid_t = c_uint;
pub const __gid_t = c_uint;
pub const __ino_t = c_ulong;
pub const __ino64_t = c_ulong;
pub const __mode_t = c_uint;
pub const __nlink_t = c_ulong;
pub const __off_t = c_long;
pub const __off64_t = c_long;
pub const __pid_t = c_int;
pub const __fsid_t = extern struct {
    __val: [2]c_int = @import("std").mem.zeroes([2]c_int),
};
pub const __clock_t = c_long;
pub const __rlim_t = c_ulong;
pub const __rlim64_t = c_ulong;
pub const __id_t = c_uint;
pub const __time_t = c_long;
pub const __useconds_t = c_uint;
pub const __suseconds_t = c_long;
pub const __suseconds64_t = c_long;
pub const __daddr_t = c_int;
pub const __key_t = c_int;
pub const __clockid_t = c_int;
pub const __timer_t = ?*anyopaque;
pub const __blksize_t = c_long;
pub const __blkcnt_t = c_long;
pub const __blkcnt64_t = c_long;
pub const __fsblkcnt_t = c_ulong;
pub const __fsblkcnt64_t = c_ulong;
pub const __fsfilcnt_t = c_ulong;
pub const __fsfilcnt64_t = c_ulong;
pub const __fsword_t = c_long;
pub const __ssize_t = c_long;
pub const __syscall_slong_t = c_long;
pub const __syscall_ulong_t = c_ulong;
pub const __loff_t = __off64_t;
pub const __caddr_t = [*c]u8;
pub const __intptr_t = c_long;
pub const __socklen_t = c_uint;
pub const __sig_atomic_t = c_int;
pub const clock_t = __clock_t;
pub const time_t = __time_t;
pub const struct_tm = extern struct {
    tm_sec: c_int = @import("std").mem.zeroes(c_int),
    tm_min: c_int = @import("std").mem.zeroes(c_int),
    tm_hour: c_int = @import("std").mem.zeroes(c_int),
    tm_mday: c_int = @import("std").mem.zeroes(c_int),
    tm_mon: c_int = @import("std").mem.zeroes(c_int),
    tm_year: c_int = @import("std").mem.zeroes(c_int),
    tm_wday: c_int = @import("std").mem.zeroes(c_int),
    tm_yday: c_int = @import("std").mem.zeroes(c_int),
    tm_isdst: c_int = @import("std").mem.zeroes(c_int),
    tm_gmtoff: c_long = @import("std").mem.zeroes(c_long),
    tm_zone: [*c]const u8 = @import("std").mem.zeroes([*c]const u8),
};
pub const struct_timespec = extern struct {
    tv_sec: __time_t = @import("std").mem.zeroes(__time_t),
    tv_nsec: __syscall_slong_t = @import("std").mem.zeroes(__syscall_slong_t),
};
pub const clockid_t = __clockid_t;
pub const timer_t = __timer_t;
pub const struct_itimerspec = extern struct {
    it_interval: struct_timespec = @import("std").mem.zeroes(struct_timespec),
    it_value: struct_timespec = @import("std").mem.zeroes(struct_timespec),
};
pub const struct_sigevent = opaque {};
pub const pid_t = __pid_t;
pub const struct___locale_data_1 = opaque {};
pub const struct___locale_struct = extern struct {
    __locales: [13]?*struct___locale_data_1 = @import("std").mem.zeroes([13]?*struct___locale_data_1),
    __ctype_b: [*c]const c_ushort = @import("std").mem.zeroes([*c]const c_ushort),
    __ctype_tolower: [*c]const c_int = @import("std").mem.zeroes([*c]const c_int),
    __ctype_toupper: [*c]const c_int = @import("std").mem.zeroes([*c]const c_int),
    __names: [13][*c]const u8 = @import("std").mem.zeroes([13][*c]const u8),
};
pub const __locale_t = [*c]struct___locale_struct;
pub const locale_t = __locale_t;
pub extern fn clock() clock_t;
pub extern fn time(__timer: [*c]time_t) time_t;
pub extern fn difftime(__time1: time_t, __time0: time_t) f64;
pub extern fn mktime(__tp: [*c]struct_tm) time_t;
pub extern fn strftime(noalias __s: [*c]u8, __maxsize: usize, noalias __format: [*c]const u8, noalias __tp: [*c]const struct_tm) usize;
pub extern fn strftime_l(noalias __s: [*c]u8, __maxsize: usize, noalias __format: [*c]const u8, noalias __tp: [*c]const struct_tm, __loc: locale_t) usize;
pub extern fn gmtime(__timer: [*c]const time_t) [*c]struct_tm;
pub extern fn localtime(__timer: [*c]const time_t) [*c]struct_tm;
pub extern fn gmtime_r(noalias __timer: [*c]const time_t, noalias __tp: [*c]struct_tm) [*c]struct_tm;
pub extern fn localtime_r(noalias __timer: [*c]const time_t, noalias __tp: [*c]struct_tm) [*c]struct_tm;
pub extern fn asctime(__tp: [*c]const struct_tm) [*c]u8;
pub extern fn ctime(__timer: [*c]const time_t) [*c]u8;
pub extern fn asctime_r(noalias __tp: [*c]const struct_tm, noalias __buf: [*c]u8) [*c]u8;
pub extern fn ctime_r(noalias __timer: [*c]const time_t, noalias __buf: [*c]u8) [*c]u8;
pub extern var __tzname: [2][*c]u8;
pub extern var __daylight: c_int;
pub extern var __timezone: c_long;
pub extern var tzname: [2][*c]u8;
pub extern fn tzset() void;
pub extern var daylight: c_int;
pub extern var timezone: c_long;
pub extern fn timegm(__tp: [*c]struct_tm) time_t;
pub extern fn timelocal(__tp: [*c]struct_tm) time_t;
pub extern fn dysize(__year: c_int) c_int;
pub extern fn nanosleep(__requested_time: [*c]const struct_timespec, __remaining: [*c]struct_timespec) c_int;
pub extern fn clock_getres(__clock_id: clockid_t, __res: [*c]struct_timespec) c_int;
pub extern fn clock_gettime(__clock_id: clockid_t, __tp: [*c]struct_timespec) c_int;
pub extern fn clock_settime(__clock_id: clockid_t, __tp: [*c]const struct_timespec) c_int;
pub extern fn clock_nanosleep(__clock_id: clockid_t, __flags: c_int, __req: [*c]const struct_timespec, __rem: [*c]struct_timespec) c_int;
pub extern fn clock_getcpuclockid(__pid: pid_t, __clock_id: [*c]clockid_t) c_int;
pub extern fn timer_create(__clock_id: clockid_t, noalias __evp: ?*struct_sigevent, noalias __timerid: [*c]timer_t) c_int;
pub extern fn timer_delete(__timerid: timer_t) c_int;
pub extern fn timer_settime(__timerid: timer_t, __flags: c_int, noalias __value: [*c]const struct_itimerspec, noalias __ovalue: [*c]struct_itimerspec) c_int;
pub extern fn timer_gettime(__timerid: timer_t, __value: [*c]struct_itimerspec) c_int;
pub extern fn timer_getoverrun(__timerid: timer_t) c_int;
pub extern fn timespec_get(__ts: [*c]struct_timespec, __base: c_int) c_int;
pub const CXFile = ?*anyopaque;
pub extern fn clang_getFileName(SFile: CXFile) CXString;
pub extern fn clang_getFileTime(SFile: CXFile) time_t;
pub const CXFileUniqueID = extern struct {
    data: [3]c_ulonglong = @import("std").mem.zeroes([3]c_ulonglong),
};
pub extern fn clang_getFileUniqueID(file: CXFile, outID: [*c]CXFileUniqueID) c_int;
pub extern fn clang_File_isEqual(file1: CXFile, file2: CXFile) c_int;
pub extern fn clang_File_tryGetRealPathName(file: CXFile) CXString;
pub const CXSourceLocation = extern struct {
    ptr_data: [2]?*const anyopaque = @import("std").mem.zeroes([2]?*const anyopaque),
    int_data: c_uint = @import("std").mem.zeroes(c_uint),
};
pub const CXSourceRange = extern struct {
    ptr_data: [2]?*const anyopaque = @import("std").mem.zeroes([2]?*const anyopaque),
    begin_int_data: c_uint = @import("std").mem.zeroes(c_uint),
    end_int_data: c_uint = @import("std").mem.zeroes(c_uint),
};
pub extern fn clang_getNullLocation() CXSourceLocation;
pub extern fn clang_equalLocations(loc1: CXSourceLocation, loc2: CXSourceLocation) c_uint;
pub extern fn clang_Location_isInSystemHeader(location: CXSourceLocation) c_int;
pub extern fn clang_Location_isFromMainFile(location: CXSourceLocation) c_int;
pub extern fn clang_getNullRange() CXSourceRange;
pub extern fn clang_getRange(begin: CXSourceLocation, end: CXSourceLocation) CXSourceRange;
pub extern fn clang_equalRanges(range1: CXSourceRange, range2: CXSourceRange) c_uint;
pub extern fn clang_Range_isNull(range: CXSourceRange) c_int;
pub extern fn clang_getExpansionLocation(location: CXSourceLocation, file: [*c]CXFile, line: [*c]c_uint, column: [*c]c_uint, offset: [*c]c_uint) void;
pub extern fn clang_getPresumedLocation(location: CXSourceLocation, filename: [*c]CXString, line: [*c]c_uint, column: [*c]c_uint) void;
pub extern fn clang_getInstantiationLocation(location: CXSourceLocation, file: [*c]CXFile, line: [*c]c_uint, column: [*c]c_uint, offset: [*c]c_uint) void;
pub extern fn clang_getSpellingLocation(location: CXSourceLocation, file: [*c]CXFile, line: [*c]c_uint, column: [*c]c_uint, offset: [*c]c_uint) void;
pub extern fn clang_getFileLocation(location: CXSourceLocation, file: [*c]CXFile, line: [*c]c_uint, column: [*c]c_uint, offset: [*c]c_uint) void;
pub extern fn clang_getRangeStart(range: CXSourceRange) CXSourceLocation;
pub extern fn clang_getRangeEnd(range: CXSourceRange) CXSourceLocation;
pub const CXSourceRangeList = extern struct {
    count: c_uint = @import("std").mem.zeroes(c_uint),
    ranges: [*c]CXSourceRange = @import("std").mem.zeroes([*c]CXSourceRange),
};
pub extern fn clang_disposeSourceRangeList(ranges: [*c]CXSourceRangeList) void;
pub const CXDiagnostic_Ignored: c_int = 0;
pub const CXDiagnostic_Note: c_int = 1;
pub const CXDiagnostic_Warning: c_int = 2;
pub const CXDiagnostic_Error: c_int = 3;
pub const CXDiagnostic_Fatal: c_int = 4;
pub const enum_CXDiagnosticSeverity = c_uint;
pub const CXDiagnostic = ?*anyopaque;
pub const CXDiagnosticSet = ?*anyopaque;
pub extern fn clang_getNumDiagnosticsInSet(Diags: CXDiagnosticSet) c_uint;
pub extern fn clang_getDiagnosticInSet(Diags: CXDiagnosticSet, Index: c_uint) CXDiagnostic;
pub const CXLoadDiag_None: c_int = 0;
pub const CXLoadDiag_Unknown: c_int = 1;
pub const CXLoadDiag_CannotLoad: c_int = 2;
pub const CXLoadDiag_InvalidFile: c_int = 3;
pub const enum_CXLoadDiag_Error = c_uint;
pub extern fn clang_loadDiagnostics(file: [*c]const u8, @"error": [*c]enum_CXLoadDiag_Error, errorString: [*c]CXString) CXDiagnosticSet;
pub extern fn clang_disposeDiagnosticSet(Diags: CXDiagnosticSet) void;
pub extern fn clang_getChildDiagnostics(D: CXDiagnostic) CXDiagnosticSet;
pub extern fn clang_disposeDiagnostic(Diagnostic: CXDiagnostic) void;
pub const CXDiagnostic_DisplaySourceLocation: c_int = 1;
pub const CXDiagnostic_DisplayColumn: c_int = 2;
pub const CXDiagnostic_DisplaySourceRanges: c_int = 4;
pub const CXDiagnostic_DisplayOption: c_int = 8;
pub const CXDiagnostic_DisplayCategoryId: c_int = 16;
pub const CXDiagnostic_DisplayCategoryName: c_int = 32;
pub const enum_CXDiagnosticDisplayOptions = c_uint;
pub extern fn clang_formatDiagnostic(Diagnostic: CXDiagnostic, Options: c_uint) CXString;
pub extern fn clang_defaultDiagnosticDisplayOptions() c_uint;
pub extern fn clang_getDiagnosticSeverity(CXDiagnostic) enum_CXDiagnosticSeverity;
pub extern fn clang_getDiagnosticLocation(CXDiagnostic) CXSourceLocation;
pub extern fn clang_getDiagnosticSpelling(CXDiagnostic) CXString;
pub extern fn clang_getDiagnosticOption(Diag: CXDiagnostic, Disable: [*c]CXString) CXString;
pub extern fn clang_getDiagnosticCategory(CXDiagnostic) c_uint;
pub extern fn clang_getDiagnosticCategoryName(Category: c_uint) CXString;
pub extern fn clang_getDiagnosticCategoryText(CXDiagnostic) CXString;
pub extern fn clang_getDiagnosticNumRanges(CXDiagnostic) c_uint;
pub extern fn clang_getDiagnosticRange(Diagnostic: CXDiagnostic, Range: c_uint) CXSourceRange;
pub extern fn clang_getDiagnosticNumFixIts(Diagnostic: CXDiagnostic) c_uint;
pub extern fn clang_getDiagnosticFixIt(Diagnostic: CXDiagnostic, FixIt: c_uint, ReplacementRange: [*c]CXSourceRange) CXString;
pub const CXIndex = ?*anyopaque;
pub const struct_CXTargetInfoImpl = opaque {};
pub const CXTargetInfo = ?*struct_CXTargetInfoImpl;
pub const struct_CXTranslationUnitImpl = opaque {};
pub const CXTranslationUnit = ?*struct_CXTranslationUnitImpl;
pub const CXClientData = ?*anyopaque;
pub const struct_CXUnsavedFile = extern struct {
    Filename: [*c]const u8 = @import("std").mem.zeroes([*c]const u8),
    Contents: [*c]const u8 = @import("std").mem.zeroes([*c]const u8),
    Length: c_ulong = @import("std").mem.zeroes(c_ulong),
};
pub const CXAvailability_Available: c_int = 0;
pub const CXAvailability_Deprecated: c_int = 1;
pub const CXAvailability_NotAvailable: c_int = 2;
pub const CXAvailability_NotAccessible: c_int = 3;
pub const enum_CXAvailabilityKind = c_uint;
pub const struct_CXVersion = extern struct {
    Major: c_int = @import("std").mem.zeroes(c_int),
    Minor: c_int = @import("std").mem.zeroes(c_int),
    Subminor: c_int = @import("std").mem.zeroes(c_int),
};
pub const CXVersion = struct_CXVersion;
pub const CXCursor_ExceptionSpecificationKind_None: c_int = 0;
pub const CXCursor_ExceptionSpecificationKind_DynamicNone: c_int = 1;
pub const CXCursor_ExceptionSpecificationKind_Dynamic: c_int = 2;
pub const CXCursor_ExceptionSpecificationKind_MSAny: c_int = 3;
pub const CXCursor_ExceptionSpecificationKind_BasicNoexcept: c_int = 4;
pub const CXCursor_ExceptionSpecificationKind_ComputedNoexcept: c_int = 5;
pub const CXCursor_ExceptionSpecificationKind_Unevaluated: c_int = 6;
pub const CXCursor_ExceptionSpecificationKind_Uninstantiated: c_int = 7;
pub const CXCursor_ExceptionSpecificationKind_Unparsed: c_int = 8;
pub const CXCursor_ExceptionSpecificationKind_NoThrow: c_int = 9;
pub const enum_CXCursor_ExceptionSpecificationKind = c_uint;
pub extern fn clang_createIndex(excludeDeclarationsFromPCH: c_int, displayDiagnostics: c_int) CXIndex;
pub extern fn clang_disposeIndex(index: CXIndex) void;
pub const CXChoice_Default: c_int = 0;
pub const CXChoice_Enabled: c_int = 1;
pub const CXChoice_Disabled: c_int = 2;
pub const CXChoice = c_uint;
pub const CXGlobalOpt_None: c_int = 0;
pub const CXGlobalOpt_ThreadBackgroundPriorityForIndexing: c_int = 1;
pub const CXGlobalOpt_ThreadBackgroundPriorityForEditing: c_int = 2;
pub const CXGlobalOpt_ThreadBackgroundPriorityForAll: c_int = 3;
pub const CXGlobalOptFlags = c_uint;
// /usr/include/clang-c/Index.h:374:12: warning: struct demoted to opaque type - has bitfield
pub const struct_CXIndexOptions = opaque {};
pub const CXIndexOptions = struct_CXIndexOptions;
pub extern fn clang_createIndexWithOptions(options: ?*const CXIndexOptions) CXIndex;
pub extern fn clang_CXIndex_setGlobalOptions(CXIndex, options: c_uint) void;
pub extern fn clang_CXIndex_getGlobalOptions(CXIndex) c_uint;
pub extern fn clang_CXIndex_setInvocationEmissionPathOption(CXIndex, Path: [*c]const u8) void;
pub extern fn clang_isFileMultipleIncludeGuarded(tu: CXTranslationUnit, file: CXFile) c_uint;
pub extern fn clang_getFile(tu: CXTranslationUnit, file_name: [*c]const u8) CXFile;
pub extern fn clang_getFileContents(tu: CXTranslationUnit, file: CXFile, size: [*c]usize) [*c]const u8;
pub extern fn clang_getLocation(tu: CXTranslationUnit, file: CXFile, line: c_uint, column: c_uint) CXSourceLocation;
pub extern fn clang_getLocationForOffset(tu: CXTranslationUnit, file: CXFile, offset: c_uint) CXSourceLocation;
pub extern fn clang_getSkippedRanges(tu: CXTranslationUnit, file: CXFile) [*c]CXSourceRangeList;
pub extern fn clang_getAllSkippedRanges(tu: CXTranslationUnit) [*c]CXSourceRangeList;
pub extern fn clang_getNumDiagnostics(Unit: CXTranslationUnit) c_uint;
pub extern fn clang_getDiagnostic(Unit: CXTranslationUnit, Index: c_uint) CXDiagnostic;
pub extern fn clang_getDiagnosticSetFromTU(Unit: CXTranslationUnit) CXDiagnosticSet;
pub extern fn clang_getTranslationUnitSpelling(CTUnit: CXTranslationUnit) CXString;
pub extern fn clang_createTranslationUnitFromSourceFile(CIdx: CXIndex, source_filename: [*c]const u8, num_clang_command_line_args: c_int, clang_command_line_args: [*c]const [*c]const u8, num_unsaved_files: c_uint, unsaved_files: [*c]struct_CXUnsavedFile) CXTranslationUnit;
pub extern fn clang_createTranslationUnit(CIdx: CXIndex, ast_filename: [*c]const u8) CXTranslationUnit;
pub extern fn clang_createTranslationUnit2(CIdx: CXIndex, ast_filename: [*c]const u8, out_TU: [*c]CXTranslationUnit) enum_CXErrorCode;
pub const CXTranslationUnit_None: c_int = 0;
pub const CXTranslationUnit_DetailedPreprocessingRecord: c_int = 1;
pub const CXTranslationUnit_Incomplete: c_int = 2;
pub const CXTranslationUnit_PrecompiledPreamble: c_int = 4;
pub const CXTranslationUnit_CacheCompletionResults: c_int = 8;
pub const CXTranslationUnit_ForSerialization: c_int = 16;
pub const CXTranslationUnit_CXXChainedPCH: c_int = 32;
pub const CXTranslationUnit_SkipFunctionBodies: c_int = 64;
pub const CXTranslationUnit_IncludeBriefCommentsInCodeCompletion: c_int = 128;
pub const CXTranslationUnit_CreatePreambleOnFirstParse: c_int = 256;
pub const CXTranslationUnit_KeepGoing: c_int = 512;
pub const CXTranslationUnit_SingleFileParse: c_int = 1024;
pub const CXTranslationUnit_LimitSkipFunctionBodiesToPreamble: c_int = 2048;
pub const CXTranslationUnit_IncludeAttributedTypes: c_int = 4096;
pub const CXTranslationUnit_VisitImplicitAttributes: c_int = 8192;
pub const CXTranslationUnit_IgnoreNonErrorsFromIncludedFiles: c_int = 16384;
pub const CXTranslationUnit_RetainExcludedConditionalBlocks: c_int = 32768;
pub const enum_CXTranslationUnit_Flags = c_uint;
pub extern fn clang_defaultEditingTranslationUnitOptions() c_uint;
pub extern fn clang_parseTranslationUnit(CIdx: CXIndex, source_filename: [*c]const u8, command_line_args: [*c]const [*c]const u8, num_command_line_args: c_int, unsaved_files: [*c]struct_CXUnsavedFile, num_unsaved_files: c_uint, options: c_uint) CXTranslationUnit;
pub extern fn clang_parseTranslationUnit2(CIdx: CXIndex, source_filename: [*c]const u8, command_line_args: [*c]const [*c]const u8, num_command_line_args: c_int, unsaved_files: [*c]struct_CXUnsavedFile, num_unsaved_files: c_uint, options: c_uint, out_TU: [*c]CXTranslationUnit) enum_CXErrorCode;
pub extern fn clang_parseTranslationUnit2FullArgv(CIdx: CXIndex, source_filename: [*c]const u8, command_line_args: [*c]const [*c]const u8, num_command_line_args: c_int, unsaved_files: [*c]struct_CXUnsavedFile, num_unsaved_files: c_uint, options: c_uint, out_TU: [*c]CXTranslationUnit) enum_CXErrorCode;
pub const CXSaveTranslationUnit_None: c_int = 0;
pub const enum_CXSaveTranslationUnit_Flags = c_uint;
pub extern fn clang_defaultSaveOptions(TU: CXTranslationUnit) c_uint;
pub const CXSaveError_None: c_int = 0;
pub const CXSaveError_Unknown: c_int = 1;
pub const CXSaveError_TranslationErrors: c_int = 2;
pub const CXSaveError_InvalidTU: c_int = 3;
pub const enum_CXSaveError = c_uint;
pub extern fn clang_saveTranslationUnit(TU: CXTranslationUnit, FileName: [*c]const u8, options: c_uint) c_int;
pub extern fn clang_suspendTranslationUnit(CXTranslationUnit) c_uint;
pub extern fn clang_disposeTranslationUnit(CXTranslationUnit) void;
pub const CXReparse_None: c_int = 0;
pub const enum_CXReparse_Flags = c_uint;
pub extern fn clang_defaultReparseOptions(TU: CXTranslationUnit) c_uint;
pub extern fn clang_reparseTranslationUnit(TU: CXTranslationUnit, num_unsaved_files: c_uint, unsaved_files: [*c]struct_CXUnsavedFile, options: c_uint) c_int;
pub const CXTUResourceUsage_AST: c_int = 1;
pub const CXTUResourceUsage_Identifiers: c_int = 2;
pub const CXTUResourceUsage_Selectors: c_int = 3;
pub const CXTUResourceUsage_GlobalCompletionResults: c_int = 4;
pub const CXTUResourceUsage_SourceManagerContentCache: c_int = 5;
pub const CXTUResourceUsage_AST_SideTables: c_int = 6;
pub const CXTUResourceUsage_SourceManager_Membuffer_Malloc: c_int = 7;
pub const CXTUResourceUsage_SourceManager_Membuffer_MMap: c_int = 8;
pub const CXTUResourceUsage_ExternalASTSource_Membuffer_Malloc: c_int = 9;
pub const CXTUResourceUsage_ExternalASTSource_Membuffer_MMap: c_int = 10;
pub const CXTUResourceUsage_Preprocessor: c_int = 11;
pub const CXTUResourceUsage_PreprocessingRecord: c_int = 12;
pub const CXTUResourceUsage_SourceManager_DataStructures: c_int = 13;
pub const CXTUResourceUsage_Preprocessor_HeaderSearch: c_int = 14;
pub const CXTUResourceUsage_MEMORY_IN_BYTES_BEGIN: c_int = 1;
pub const CXTUResourceUsage_MEMORY_IN_BYTES_END: c_int = 14;
pub const CXTUResourceUsage_First: c_int = 1;
pub const CXTUResourceUsage_Last: c_int = 14;
pub const enum_CXTUResourceUsageKind = c_uint;
pub extern fn clang_getTUResourceUsageName(kind: enum_CXTUResourceUsageKind) [*c]const u8;
pub const struct_CXTUResourceUsageEntry = extern struct {
    kind: enum_CXTUResourceUsageKind = @import("std").mem.zeroes(enum_CXTUResourceUsageKind),
    amount: c_ulong = @import("std").mem.zeroes(c_ulong),
};
pub const CXTUResourceUsageEntry = struct_CXTUResourceUsageEntry;
pub const struct_CXTUResourceUsage = extern struct {
    data: ?*anyopaque = @import("std").mem.zeroes(?*anyopaque),
    numEntries: c_uint = @import("std").mem.zeroes(c_uint),
    entries: [*c]CXTUResourceUsageEntry = @import("std").mem.zeroes([*c]CXTUResourceUsageEntry),
};
pub const CXTUResourceUsage = struct_CXTUResourceUsage;
pub extern fn clang_getCXTUResourceUsage(TU: CXTranslationUnit) CXTUResourceUsage;
pub extern fn clang_disposeCXTUResourceUsage(usage: CXTUResourceUsage) void;
pub extern fn clang_getTranslationUnitTargetInfo(CTUnit: CXTranslationUnit) CXTargetInfo;
pub extern fn clang_TargetInfo_dispose(Info: CXTargetInfo) void;
pub extern fn clang_TargetInfo_getTriple(Info: CXTargetInfo) CXString;
pub extern fn clang_TargetInfo_getPointerWidth(Info: CXTargetInfo) c_int;
pub const CXCursor_UnexposedDecl: c_int = 1;
pub const CXCursor_StructDecl: c_int = 2;
pub const CXCursor_UnionDecl: c_int = 3;
pub const CXCursor_ClassDecl: c_int = 4;
pub const CXCursor_EnumDecl: c_int = 5;
pub const CXCursor_FieldDecl: c_int = 6;
pub const CXCursor_EnumConstantDecl: c_int = 7;
pub const CXCursor_FunctionDecl: c_int = 8;
pub const CXCursor_VarDecl: c_int = 9;
pub const CXCursor_ParmDecl: c_int = 10;
pub const CXCursor_ObjCInterfaceDecl: c_int = 11;
pub const CXCursor_ObjCCategoryDecl: c_int = 12;
pub const CXCursor_ObjCProtocolDecl: c_int = 13;
pub const CXCursor_ObjCPropertyDecl: c_int = 14;
pub const CXCursor_ObjCIvarDecl: c_int = 15;
pub const CXCursor_ObjCInstanceMethodDecl: c_int = 16;
pub const CXCursor_ObjCClassMethodDecl: c_int = 17;
pub const CXCursor_ObjCImplementationDecl: c_int = 18;
pub const CXCursor_ObjCCategoryImplDecl: c_int = 19;
pub const CXCursor_TypedefDecl: c_int = 20;
pub const CXCursor_CXXMethod: c_int = 21;
pub const CXCursor_Namespace: c_int = 22;
pub const CXCursor_LinkageSpec: c_int = 23;
pub const CXCursor_Constructor: c_int = 24;
pub const CXCursor_Destructor: c_int = 25;
pub const CXCursor_ConversionFunction: c_int = 26;
pub const CXCursor_TemplateTypeParameter: c_int = 27;
pub const CXCursor_NonTypeTemplateParameter: c_int = 28;
pub const CXCursor_TemplateTemplateParameter: c_int = 29;
pub const CXCursor_FunctionTemplate: c_int = 30;
pub const CXCursor_ClassTemplate: c_int = 31;
pub const CXCursor_ClassTemplatePartialSpecialization: c_int = 32;
pub const CXCursor_NamespaceAlias: c_int = 33;
pub const CXCursor_UsingDirective: c_int = 34;
pub const CXCursor_UsingDeclaration: c_int = 35;
pub const CXCursor_TypeAliasDecl: c_int = 36;
pub const CXCursor_ObjCSynthesizeDecl: c_int = 37;
pub const CXCursor_ObjCDynamicDecl: c_int = 38;
pub const CXCursor_CXXAccessSpecifier: c_int = 39;
pub const CXCursor_FirstDecl: c_int = 1;
pub const CXCursor_LastDecl: c_int = 39;
pub const CXCursor_FirstRef: c_int = 40;
pub const CXCursor_ObjCSuperClassRef: c_int = 40;
pub const CXCursor_ObjCProtocolRef: c_int = 41;
pub const CXCursor_ObjCClassRef: c_int = 42;
pub const CXCursor_TypeRef: c_int = 43;
pub const CXCursor_CXXBaseSpecifier: c_int = 44;
pub const CXCursor_TemplateRef: c_int = 45;
pub const CXCursor_NamespaceRef: c_int = 46;
pub const CXCursor_MemberRef: c_int = 47;
pub const CXCursor_LabelRef: c_int = 48;
pub const CXCursor_OverloadedDeclRef: c_int = 49;
pub const CXCursor_VariableRef: c_int = 50;
pub const CXCursor_LastRef: c_int = 50;
pub const CXCursor_FirstInvalid: c_int = 70;
pub const CXCursor_InvalidFile: c_int = 70;
pub const CXCursor_NoDeclFound: c_int = 71;
pub const CXCursor_NotImplemented: c_int = 72;
pub const CXCursor_InvalidCode: c_int = 73;
pub const CXCursor_LastInvalid: c_int = 73;
pub const CXCursor_FirstExpr: c_int = 100;
pub const CXCursor_UnexposedExpr: c_int = 100;
pub const CXCursor_DeclRefExpr: c_int = 101;
pub const CXCursor_MemberRefExpr: c_int = 102;
pub const CXCursor_CallExpr: c_int = 103;
pub const CXCursor_ObjCMessageExpr: c_int = 104;
pub const CXCursor_BlockExpr: c_int = 105;
pub const CXCursor_IntegerLiteral: c_int = 106;
pub const CXCursor_FloatingLiteral: c_int = 107;
pub const CXCursor_ImaginaryLiteral: c_int = 108;
pub const CXCursor_StringLiteral: c_int = 109;
pub const CXCursor_CharacterLiteral: c_int = 110;
pub const CXCursor_ParenExpr: c_int = 111;
pub const CXCursor_UnaryOperator: c_int = 112;
pub const CXCursor_ArraySubscriptExpr: c_int = 113;
pub const CXCursor_BinaryOperator: c_int = 114;
pub const CXCursor_CompoundAssignOperator: c_int = 115;
pub const CXCursor_ConditionalOperator: c_int = 116;
pub const CXCursor_CStyleCastExpr: c_int = 117;
pub const CXCursor_CompoundLiteralExpr: c_int = 118;
pub const CXCursor_InitListExpr: c_int = 119;
pub const CXCursor_AddrLabelExpr: c_int = 120;
pub const CXCursor_StmtExpr: c_int = 121;
pub const CXCursor_GenericSelectionExpr: c_int = 122;
pub const CXCursor_GNUNullExpr: c_int = 123;
pub const CXCursor_CXXStaticCastExpr: c_int = 124;
pub const CXCursor_CXXDynamicCastExpr: c_int = 125;
pub const CXCursor_CXXReinterpretCastExpr: c_int = 126;
pub const CXCursor_CXXConstCastExpr: c_int = 127;
pub const CXCursor_CXXFunctionalCastExpr: c_int = 128;
pub const CXCursor_CXXTypeidExpr: c_int = 129;
pub const CXCursor_CXXBoolLiteralExpr: c_int = 130;
pub const CXCursor_CXXNullPtrLiteralExpr: c_int = 131;
pub const CXCursor_CXXThisExpr: c_int = 132;
pub const CXCursor_CXXThrowExpr: c_int = 133;
pub const CXCursor_CXXNewExpr: c_int = 134;
pub const CXCursor_CXXDeleteExpr: c_int = 135;
pub const CXCursor_UnaryExpr: c_int = 136;
pub const CXCursor_ObjCStringLiteral: c_int = 137;
pub const CXCursor_ObjCEncodeExpr: c_int = 138;
pub const CXCursor_ObjCSelectorExpr: c_int = 139;
pub const CXCursor_ObjCProtocolExpr: c_int = 140;
pub const CXCursor_ObjCBridgedCastExpr: c_int = 141;
pub const CXCursor_PackExpansionExpr: c_int = 142;
pub const CXCursor_SizeOfPackExpr: c_int = 143;
pub const CXCursor_LambdaExpr: c_int = 144;
pub const CXCursor_ObjCBoolLiteralExpr: c_int = 145;
pub const CXCursor_ObjCSelfExpr: c_int = 146;
pub const CXCursor_OMPArraySectionExpr: c_int = 147;
pub const CXCursor_ObjCAvailabilityCheckExpr: c_int = 148;
pub const CXCursor_FixedPointLiteral: c_int = 149;
pub const CXCursor_OMPArrayShapingExpr: c_int = 150;
pub const CXCursor_OMPIteratorExpr: c_int = 151;
pub const CXCursor_CXXAddrspaceCastExpr: c_int = 152;
pub const CXCursor_ConceptSpecializationExpr: c_int = 153;
pub const CXCursor_RequiresExpr: c_int = 154;
pub const CXCursor_CXXParenListInitExpr: c_int = 155;
pub const CXCursor_LastExpr: c_int = 155;
pub const CXCursor_FirstStmt: c_int = 200;
pub const CXCursor_UnexposedStmt: c_int = 200;
pub const CXCursor_LabelStmt: c_int = 201;
pub const CXCursor_CompoundStmt: c_int = 202;
pub const CXCursor_CaseStmt: c_int = 203;
pub const CXCursor_DefaultStmt: c_int = 204;
pub const CXCursor_IfStmt: c_int = 205;
pub const CXCursor_SwitchStmt: c_int = 206;
pub const CXCursor_WhileStmt: c_int = 207;
pub const CXCursor_DoStmt: c_int = 208;
pub const CXCursor_ForStmt: c_int = 209;
pub const CXCursor_GotoStmt: c_int = 210;
pub const CXCursor_IndirectGotoStmt: c_int = 211;
pub const CXCursor_ContinueStmt: c_int = 212;
pub const CXCursor_BreakStmt: c_int = 213;
pub const CXCursor_ReturnStmt: c_int = 214;
pub const CXCursor_GCCAsmStmt: c_int = 215;
pub const CXCursor_AsmStmt: c_int = 215;
pub const CXCursor_ObjCAtTryStmt: c_int = 216;
pub const CXCursor_ObjCAtCatchStmt: c_int = 217;
pub const CXCursor_ObjCAtFinallyStmt: c_int = 218;
pub const CXCursor_ObjCAtThrowStmt: c_int = 219;
pub const CXCursor_ObjCAtSynchronizedStmt: c_int = 220;
pub const CXCursor_ObjCAutoreleasePoolStmt: c_int = 221;
pub const CXCursor_ObjCForCollectionStmt: c_int = 222;
pub const CXCursor_CXXCatchStmt: c_int = 223;
pub const CXCursor_CXXTryStmt: c_int = 224;
pub const CXCursor_CXXForRangeStmt: c_int = 225;
pub const CXCursor_SEHTryStmt: c_int = 226;
pub const CXCursor_SEHExceptStmt: c_int = 227;
pub const CXCursor_SEHFinallyStmt: c_int = 228;
pub const CXCursor_MSAsmStmt: c_int = 229;
pub const CXCursor_NullStmt: c_int = 230;
pub const CXCursor_DeclStmt: c_int = 231;
pub const CXCursor_OMPParallelDirective: c_int = 232;
pub const CXCursor_OMPSimdDirective: c_int = 233;
pub const CXCursor_OMPForDirective: c_int = 234;
pub const CXCursor_OMPSectionsDirective: c_int = 235;
pub const CXCursor_OMPSectionDirective: c_int = 236;
pub const CXCursor_OMPSingleDirective: c_int = 237;
pub const CXCursor_OMPParallelForDirective: c_int = 238;
pub const CXCursor_OMPParallelSectionsDirective: c_int = 239;
pub const CXCursor_OMPTaskDirective: c_int = 240;
pub const CXCursor_OMPMasterDirective: c_int = 241;
pub const CXCursor_OMPCriticalDirective: c_int = 242;
pub const CXCursor_OMPTaskyieldDirective: c_int = 243;
pub const CXCursor_OMPBarrierDirective: c_int = 244;
pub const CXCursor_OMPTaskwaitDirective: c_int = 245;
pub const CXCursor_OMPFlushDirective: c_int = 246;
pub const CXCursor_SEHLeaveStmt: c_int = 247;
pub const CXCursor_OMPOrderedDirective: c_int = 248;
pub const CXCursor_OMPAtomicDirective: c_int = 249;
pub const CXCursor_OMPForSimdDirective: c_int = 250;
pub const CXCursor_OMPParallelForSimdDirective: c_int = 251;
pub const CXCursor_OMPTargetDirective: c_int = 252;
pub const CXCursor_OMPTeamsDirective: c_int = 253;
pub const CXCursor_OMPTaskgroupDirective: c_int = 254;
pub const CXCursor_OMPCancellationPointDirective: c_int = 255;
pub const CXCursor_OMPCancelDirective: c_int = 256;
pub const CXCursor_OMPTargetDataDirective: c_int = 257;
pub const CXCursor_OMPTaskLoopDirective: c_int = 258;
pub const CXCursor_OMPTaskLoopSimdDirective: c_int = 259;
pub const CXCursor_OMPDistributeDirective: c_int = 260;
pub const CXCursor_OMPTargetEnterDataDirective: c_int = 261;
pub const CXCursor_OMPTargetExitDataDirective: c_int = 262;
pub const CXCursor_OMPTargetParallelDirective: c_int = 263;
pub const CXCursor_OMPTargetParallelForDirective: c_int = 264;
pub const CXCursor_OMPTargetUpdateDirective: c_int = 265;
pub const CXCursor_OMPDistributeParallelForDirective: c_int = 266;
pub const CXCursor_OMPDistributeParallelForSimdDirective: c_int = 267;
pub const CXCursor_OMPDistributeSimdDirective: c_int = 268;
pub const CXCursor_OMPTargetParallelForSimdDirective: c_int = 269;
pub const CXCursor_OMPTargetSimdDirective: c_int = 270;
pub const CXCursor_OMPTeamsDistributeDirective: c_int = 271;
pub const CXCursor_OMPTeamsDistributeSimdDirective: c_int = 272;
pub const CXCursor_OMPTeamsDistributeParallelForSimdDirective: c_int = 273;
pub const CXCursor_OMPTeamsDistributeParallelForDirective: c_int = 274;
pub const CXCursor_OMPTargetTeamsDirective: c_int = 275;
pub const CXCursor_OMPTargetTeamsDistributeDirective: c_int = 276;
pub const CXCursor_OMPTargetTeamsDistributeParallelForDirective: c_int = 277;
pub const CXCursor_OMPTargetTeamsDistributeParallelForSimdDirective: c_int = 278;
pub const CXCursor_OMPTargetTeamsDistributeSimdDirective: c_int = 279;
pub const CXCursor_BuiltinBitCastExpr: c_int = 280;
pub const CXCursor_OMPMasterTaskLoopDirective: c_int = 281;
pub const CXCursor_OMPParallelMasterTaskLoopDirective: c_int = 282;
pub const CXCursor_OMPMasterTaskLoopSimdDirective: c_int = 283;
pub const CXCursor_OMPParallelMasterTaskLoopSimdDirective: c_int = 284;
pub const CXCursor_OMPParallelMasterDirective: c_int = 285;
pub const CXCursor_OMPDepobjDirective: c_int = 286;
pub const CXCursor_OMPScanDirective: c_int = 287;
pub const CXCursor_OMPTileDirective: c_int = 288;
pub const CXCursor_OMPCanonicalLoop: c_int = 289;
pub const CXCursor_OMPInteropDirective: c_int = 290;
pub const CXCursor_OMPDispatchDirective: c_int = 291;
pub const CXCursor_OMPMaskedDirective: c_int = 292;
pub const CXCursor_OMPUnrollDirective: c_int = 293;
pub const CXCursor_OMPMetaDirective: c_int = 294;
pub const CXCursor_OMPGenericLoopDirective: c_int = 295;
pub const CXCursor_OMPTeamsGenericLoopDirective: c_int = 296;
pub const CXCursor_OMPTargetTeamsGenericLoopDirective: c_int = 297;
pub const CXCursor_OMPParallelGenericLoopDirective: c_int = 298;
pub const CXCursor_OMPTargetParallelGenericLoopDirective: c_int = 299;
pub const CXCursor_OMPParallelMaskedDirective: c_int = 300;
pub const CXCursor_OMPMaskedTaskLoopDirective: c_int = 301;
pub const CXCursor_OMPMaskedTaskLoopSimdDirective: c_int = 302;
pub const CXCursor_OMPParallelMaskedTaskLoopDirective: c_int = 303;
pub const CXCursor_OMPParallelMaskedTaskLoopSimdDirective: c_int = 304;
pub const CXCursor_OMPErrorDirective: c_int = 305;
pub const CXCursor_OMPScopeDirective: c_int = 306;
pub const CXCursor_LastStmt: c_int = 306;
pub const CXCursor_TranslationUnit: c_int = 350;
pub const CXCursor_FirstAttr: c_int = 400;
pub const CXCursor_UnexposedAttr: c_int = 400;
pub const CXCursor_IBActionAttr: c_int = 401;
pub const CXCursor_IBOutletAttr: c_int = 402;
pub const CXCursor_IBOutletCollectionAttr: c_int = 403;
pub const CXCursor_CXXFinalAttr: c_int = 404;
pub const CXCursor_CXXOverrideAttr: c_int = 405;
pub const CXCursor_AnnotateAttr: c_int = 406;
pub const CXCursor_AsmLabelAttr: c_int = 407;
pub const CXCursor_PackedAttr: c_int = 408;
pub const CXCursor_PureAttr: c_int = 409;
pub const CXCursor_ConstAttr: c_int = 410;
pub const CXCursor_NoDuplicateAttr: c_int = 411;
pub const CXCursor_CUDAConstantAttr: c_int = 412;
pub const CXCursor_CUDADeviceAttr: c_int = 413;
pub const CXCursor_CUDAGlobalAttr: c_int = 414;
pub const CXCursor_CUDAHostAttr: c_int = 415;
pub const CXCursor_CUDASharedAttr: c_int = 416;
pub const CXCursor_VisibilityAttr: c_int = 417;
pub const CXCursor_DLLExport: c_int = 418;
pub const CXCursor_DLLImport: c_int = 419;
pub const CXCursor_NSReturnsRetained: c_int = 420;
pub const CXCursor_NSReturnsNotRetained: c_int = 421;
pub const CXCursor_NSReturnsAutoreleased: c_int = 422;
pub const CXCursor_NSConsumesSelf: c_int = 423;
pub const CXCursor_NSConsumed: c_int = 424;
pub const CXCursor_ObjCException: c_int = 425;
pub const CXCursor_ObjCNSObject: c_int = 426;
pub const CXCursor_ObjCIndependentClass: c_int = 427;
pub const CXCursor_ObjCPreciseLifetime: c_int = 428;
pub const CXCursor_ObjCReturnsInnerPointer: c_int = 429;
pub const CXCursor_ObjCRequiresSuper: c_int = 430;
pub const CXCursor_ObjCRootClass: c_int = 431;
pub const CXCursor_ObjCSubclassingRestricted: c_int = 432;
pub const CXCursor_ObjCExplicitProtocolImpl: c_int = 433;
pub const CXCursor_ObjCDesignatedInitializer: c_int = 434;
pub const CXCursor_ObjCRuntimeVisible: c_int = 435;
pub const CXCursor_ObjCBoxable: c_int = 436;
pub const CXCursor_FlagEnum: c_int = 437;
pub const CXCursor_ConvergentAttr: c_int = 438;
pub const CXCursor_WarnUnusedAttr: c_int = 439;
pub const CXCursor_WarnUnusedResultAttr: c_int = 440;
pub const CXCursor_AlignedAttr: c_int = 441;
pub const CXCursor_LastAttr: c_int = 441;
pub const CXCursor_PreprocessingDirective: c_int = 500;
pub const CXCursor_MacroDefinition: c_int = 501;
pub const CXCursor_MacroExpansion: c_int = 502;
pub const CXCursor_MacroInstantiation: c_int = 502;
pub const CXCursor_InclusionDirective: c_int = 503;
pub const CXCursor_FirstPreprocessing: c_int = 500;
pub const CXCursor_LastPreprocessing: c_int = 503;
pub const CXCursor_ModuleImportDecl: c_int = 600;
pub const CXCursor_TypeAliasTemplateDecl: c_int = 601;
pub const CXCursor_StaticAssert: c_int = 602;
pub const CXCursor_FriendDecl: c_int = 603;
pub const CXCursor_ConceptDecl: c_int = 604;
pub const CXCursor_FirstExtraDecl: c_int = 600;
pub const CXCursor_LastExtraDecl: c_int = 604;
pub const CXCursor_OverloadCandidate: c_int = 700;
pub const enum_CXCursorKind = c_uint;
pub const CXCursor = extern struct {
    kind: enum_CXCursorKind = @import("std").mem.zeroes(enum_CXCursorKind),
    xdata: c_int = @import("std").mem.zeroes(c_int),
    data: [3]?*const anyopaque = @import("std").mem.zeroes([3]?*const anyopaque),
};
pub extern fn clang_getNullCursor() CXCursor;
pub extern fn clang_getTranslationUnitCursor(CXTranslationUnit) CXCursor;
pub extern fn clang_equalCursors(CXCursor, CXCursor) c_uint;
pub extern fn clang_Cursor_isNull(cursor: CXCursor) c_int;
pub extern fn clang_hashCursor(CXCursor) c_uint;
pub extern fn clang_getCursorKind(CXCursor) enum_CXCursorKind;
pub extern fn clang_isDeclaration(enum_CXCursorKind) c_uint;
pub extern fn clang_isInvalidDeclaration(CXCursor) c_uint;
pub extern fn clang_isReference(enum_CXCursorKind) c_uint;
pub extern fn clang_isExpression(enum_CXCursorKind) c_uint;
pub extern fn clang_isStatement(enum_CXCursorKind) c_uint;
pub extern fn clang_isAttribute(enum_CXCursorKind) c_uint;
pub extern fn clang_Cursor_hasAttrs(C: CXCursor) c_uint;
pub extern fn clang_isInvalid(enum_CXCursorKind) c_uint;
pub extern fn clang_isTranslationUnit(enum_CXCursorKind) c_uint;
pub extern fn clang_isPreprocessing(enum_CXCursorKind) c_uint;
pub extern fn clang_isUnexposed(enum_CXCursorKind) c_uint;
pub const CXLinkage_Invalid: c_int = 0;
pub const CXLinkage_NoLinkage: c_int = 1;
pub const CXLinkage_Internal: c_int = 2;
pub const CXLinkage_UniqueExternal: c_int = 3;
pub const CXLinkage_External: c_int = 4;
pub const enum_CXLinkageKind = c_uint;
pub extern fn clang_getCursorLinkage(cursor: CXCursor) enum_CXLinkageKind;
pub const CXVisibility_Invalid: c_int = 0;
pub const CXVisibility_Hidden: c_int = 1;
pub const CXVisibility_Protected: c_int = 2;
pub const CXVisibility_Default: c_int = 3;
pub const enum_CXVisibilityKind = c_uint;
pub extern fn clang_getCursorVisibility(cursor: CXCursor) enum_CXVisibilityKind;
pub extern fn clang_getCursorAvailability(cursor: CXCursor) enum_CXAvailabilityKind;
pub const struct_CXPlatformAvailability = extern struct {
    Platform: CXString = @import("std").mem.zeroes(CXString),
    Introduced: CXVersion = @import("std").mem.zeroes(CXVersion),
    Deprecated: CXVersion = @import("std").mem.zeroes(CXVersion),
    Obsoleted: CXVersion = @import("std").mem.zeroes(CXVersion),
    Unavailable: c_int = @import("std").mem.zeroes(c_int),
    Message: CXString = @import("std").mem.zeroes(CXString),
};
pub const CXPlatformAvailability = struct_CXPlatformAvailability;
pub extern fn clang_getCursorPlatformAvailability(cursor: CXCursor, always_deprecated: [*c]c_int, deprecated_message: [*c]CXString, always_unavailable: [*c]c_int, unavailable_message: [*c]CXString, availability: [*c]CXPlatformAvailability, availability_size: c_int) c_int;
pub extern fn clang_disposeCXPlatformAvailability(availability: [*c]CXPlatformAvailability) void;
pub extern fn clang_Cursor_getVarDeclInitializer(cursor: CXCursor) CXCursor;
pub extern fn clang_Cursor_hasVarDeclGlobalStorage(cursor: CXCursor) c_int;
pub extern fn clang_Cursor_hasVarDeclExternalStorage(cursor: CXCursor) c_int;
pub const CXLanguage_Invalid: c_int = 0;
pub const CXLanguage_C: c_int = 1;
pub const CXLanguage_ObjC: c_int = 2;
pub const CXLanguage_CPlusPlus: c_int = 3;
pub const enum_CXLanguageKind = c_uint;
pub extern fn clang_getCursorLanguage(cursor: CXCursor) enum_CXLanguageKind;
pub const CXTLS_None: c_int = 0;
pub const CXTLS_Dynamic: c_int = 1;
pub const CXTLS_Static: c_int = 2;
pub const enum_CXTLSKind = c_uint;
pub extern fn clang_getCursorTLSKind(cursor: CXCursor) enum_CXTLSKind;
pub extern fn clang_Cursor_getTranslationUnit(CXCursor) CXTranslationUnit;
pub const struct_CXCursorSetImpl = opaque {};
pub const CXCursorSet = ?*struct_CXCursorSetImpl;
pub extern fn clang_createCXCursorSet() CXCursorSet;
pub extern fn clang_disposeCXCursorSet(cset: CXCursorSet) void;
pub extern fn clang_CXCursorSet_contains(cset: CXCursorSet, cursor: CXCursor) c_uint;
pub extern fn clang_CXCursorSet_insert(cset: CXCursorSet, cursor: CXCursor) c_uint;
pub extern fn clang_getCursorSemanticParent(cursor: CXCursor) CXCursor;
pub extern fn clang_getCursorLexicalParent(cursor: CXCursor) CXCursor;
pub extern fn clang_getOverriddenCursors(cursor: CXCursor, overridden: [*c][*c]CXCursor, num_overridden: [*c]c_uint) void;
pub extern fn clang_disposeOverriddenCursors(overridden: [*c]CXCursor) void;
pub extern fn clang_getIncludedFile(cursor: CXCursor) CXFile;
pub extern fn clang_getCursor(CXTranslationUnit, CXSourceLocation) CXCursor;
pub extern fn clang_getCursorLocation(CXCursor) CXSourceLocation;
pub extern fn clang_getCursorExtent(CXCursor) CXSourceRange;
pub const CXType_Invalid: c_int = 0;
pub const CXType_Unexposed: c_int = 1;
pub const CXType_Void: c_int = 2;
pub const CXType_Bool: c_int = 3;
pub const CXType_Char_U: c_int = 4;
pub const CXType_UChar: c_int = 5;
pub const CXType_Char16: c_int = 6;
pub const CXType_Char32: c_int = 7;
pub const CXType_UShort: c_int = 8;
pub const CXType_UInt: c_int = 9;
pub const CXType_ULong: c_int = 10;
pub const CXType_ULongLong: c_int = 11;
pub const CXType_UInt128: c_int = 12;
pub const CXType_Char_S: c_int = 13;
pub const CXType_SChar: c_int = 14;
pub const CXType_WChar: c_int = 15;
pub const CXType_Short: c_int = 16;
pub const CXType_Int: c_int = 17;
pub const CXType_Long: c_int = 18;
pub const CXType_LongLong: c_int = 19;
pub const CXType_Int128: c_int = 20;
pub const CXType_Float: c_int = 21;
pub const CXType_Double: c_int = 22;
pub const CXType_LongDouble: c_int = 23;
pub const CXType_NullPtr: c_int = 24;
pub const CXType_Overload: c_int = 25;
pub const CXType_Dependent: c_int = 26;
pub const CXType_ObjCId: c_int = 27;
pub const CXType_ObjCClass: c_int = 28;
pub const CXType_ObjCSel: c_int = 29;
pub const CXType_Float128: c_int = 30;
pub const CXType_Half: c_int = 31;
pub const CXType_Float16: c_int = 32;
pub const CXType_ShortAccum: c_int = 33;
pub const CXType_Accum: c_int = 34;
pub const CXType_LongAccum: c_int = 35;
pub const CXType_UShortAccum: c_int = 36;
pub const CXType_UAccum: c_int = 37;
pub const CXType_ULongAccum: c_int = 38;
pub const CXType_BFloat16: c_int = 39;
pub const CXType_Ibm128: c_int = 40;
pub const CXType_FirstBuiltin: c_int = 2;
pub const CXType_LastBuiltin: c_int = 40;
pub const CXType_Complex: c_int = 100;
pub const CXType_Pointer: c_int = 101;
pub const CXType_BlockPointer: c_int = 102;
pub const CXType_LValueReference: c_int = 103;
pub const CXType_RValueReference: c_int = 104;
pub const CXType_Record: c_int = 105;
pub const CXType_Enum: c_int = 106;
pub const CXType_Typedef: c_int = 107;
pub const CXType_ObjCInterface: c_int = 108;
pub const CXType_ObjCObjectPointer: c_int = 109;
pub const CXType_FunctionNoProto: c_int = 110;
pub const CXType_FunctionProto: c_int = 111;
pub const CXType_ConstantArray: c_int = 112;
pub const CXType_Vector: c_int = 113;
pub const CXType_IncompleteArray: c_int = 114;
pub const CXType_VariableArray: c_int = 115;
pub const CXType_DependentSizedArray: c_int = 116;
pub const CXType_MemberPointer: c_int = 117;
pub const CXType_Auto: c_int = 118;
pub const CXType_Elaborated: c_int = 119;
pub const CXType_Pipe: c_int = 120;
pub const CXType_OCLImage1dRO: c_int = 121;
pub const CXType_OCLImage1dArrayRO: c_int = 122;
pub const CXType_OCLImage1dBufferRO: c_int = 123;
pub const CXType_OCLImage2dRO: c_int = 124;
pub const CXType_OCLImage2dArrayRO: c_int = 125;
pub const CXType_OCLImage2dDepthRO: c_int = 126;
pub const CXType_OCLImage2dArrayDepthRO: c_int = 127;
pub const CXType_OCLImage2dMSAARO: c_int = 128;
pub const CXType_OCLImage2dArrayMSAARO: c_int = 129;
pub const CXType_OCLImage2dMSAADepthRO: c_int = 130;
pub const CXType_OCLImage2dArrayMSAADepthRO: c_int = 131;
pub const CXType_OCLImage3dRO: c_int = 132;
pub const CXType_OCLImage1dWO: c_int = 133;
pub const CXType_OCLImage1dArrayWO: c_int = 134;
pub const CXType_OCLImage1dBufferWO: c_int = 135;
pub const CXType_OCLImage2dWO: c_int = 136;
pub const CXType_OCLImage2dArrayWO: c_int = 137;
pub const CXType_OCLImage2dDepthWO: c_int = 138;
pub const CXType_OCLImage2dArrayDepthWO: c_int = 139;
pub const CXType_OCLImage2dMSAAWO: c_int = 140;
pub const CXType_OCLImage2dArrayMSAAWO: c_int = 141;
pub const CXType_OCLImage2dMSAADepthWO: c_int = 142;
pub const CXType_OCLImage2dArrayMSAADepthWO: c_int = 143;
pub const CXType_OCLImage3dWO: c_int = 144;
pub const CXType_OCLImage1dRW: c_int = 145;
pub const CXType_OCLImage1dArrayRW: c_int = 146;
pub const CXType_OCLImage1dBufferRW: c_int = 147;
pub const CXType_OCLImage2dRW: c_int = 148;
pub const CXType_OCLImage2dArrayRW: c_int = 149;
pub const CXType_OCLImage2dDepthRW: c_int = 150;
pub const CXType_OCLImage2dArrayDepthRW: c_int = 151;
pub const CXType_OCLImage2dMSAARW: c_int = 152;
pub const CXType_OCLImage2dArrayMSAARW: c_int = 153;
pub const CXType_OCLImage2dMSAADepthRW: c_int = 154;
pub const CXType_OCLImage2dArrayMSAADepthRW: c_int = 155;
pub const CXType_OCLImage3dRW: c_int = 156;
pub const CXType_OCLSampler: c_int = 157;
pub const CXType_OCLEvent: c_int = 158;
pub const CXType_OCLQueue: c_int = 159;
pub const CXType_OCLReserveID: c_int = 160;
pub const CXType_ObjCObject: c_int = 161;
pub const CXType_ObjCTypeParam: c_int = 162;
pub const CXType_Attributed: c_int = 163;
pub const CXType_OCLIntelSubgroupAVCMcePayload: c_int = 164;
pub const CXType_OCLIntelSubgroupAVCImePayload: c_int = 165;
pub const CXType_OCLIntelSubgroupAVCRefPayload: c_int = 166;
pub const CXType_OCLIntelSubgroupAVCSicPayload: c_int = 167;
pub const CXType_OCLIntelSubgroupAVCMceResult: c_int = 168;
pub const CXType_OCLIntelSubgroupAVCImeResult: c_int = 169;
pub const CXType_OCLIntelSubgroupAVCRefResult: c_int = 170;
pub const CXType_OCLIntelSubgroupAVCSicResult: c_int = 171;
pub const CXType_OCLIntelSubgroupAVCImeResultSingleReferenceStreamout: c_int = 172;
pub const CXType_OCLIntelSubgroupAVCImeResultDualReferenceStreamout: c_int = 173;
pub const CXType_OCLIntelSubgroupAVCImeSingleReferenceStreamin: c_int = 174;
pub const CXType_OCLIntelSubgroupAVCImeDualReferenceStreamin: c_int = 175;
pub const CXType_OCLIntelSubgroupAVCImeResultSingleRefStreamout: c_int = 172;
pub const CXType_OCLIntelSubgroupAVCImeResultDualRefStreamout: c_int = 173;
pub const CXType_OCLIntelSubgroupAVCImeSingleRefStreamin: c_int = 174;
pub const CXType_OCLIntelSubgroupAVCImeDualRefStreamin: c_int = 175;
pub const CXType_ExtVector: c_int = 176;
pub const CXType_Atomic: c_int = 177;
pub const CXType_BTFTagAttributed: c_int = 178;
pub const enum_CXTypeKind = c_uint;
pub const CXCallingConv_Default: c_int = 0;
pub const CXCallingConv_C: c_int = 1;
pub const CXCallingConv_X86StdCall: c_int = 2;
pub const CXCallingConv_X86FastCall: c_int = 3;
pub const CXCallingConv_X86ThisCall: c_int = 4;
pub const CXCallingConv_X86Pascal: c_int = 5;
pub const CXCallingConv_AAPCS: c_int = 6;
pub const CXCallingConv_AAPCS_VFP: c_int = 7;
pub const CXCallingConv_X86RegCall: c_int = 8;
pub const CXCallingConv_IntelOclBicc: c_int = 9;
pub const CXCallingConv_Win64: c_int = 10;
pub const CXCallingConv_X86_64Win64: c_int = 10;
pub const CXCallingConv_X86_64SysV: c_int = 11;
pub const CXCallingConv_X86VectorCall: c_int = 12;
pub const CXCallingConv_Swift: c_int = 13;
pub const CXCallingConv_PreserveMost: c_int = 14;
pub const CXCallingConv_PreserveAll: c_int = 15;
pub const CXCallingConv_AArch64VectorCall: c_int = 16;
pub const CXCallingConv_SwiftAsync: c_int = 17;
pub const CXCallingConv_AArch64SVEPCS: c_int = 18;
pub const CXCallingConv_M68kRTD: c_int = 19;
pub const CXCallingConv_Invalid: c_int = 100;
pub const CXCallingConv_Unexposed: c_int = 200;
pub const enum_CXCallingConv = c_uint;
pub const CXType = extern struct {
    kind: enum_CXTypeKind = @import("std").mem.zeroes(enum_CXTypeKind),
    data: [2]?*anyopaque = @import("std").mem.zeroes([2]?*anyopaque),
};
pub extern fn clang_getCursorType(C: CXCursor) CXType;
pub extern fn clang_getTypeSpelling(CT: CXType) CXString;
pub extern fn clang_getTypedefDeclUnderlyingType(C: CXCursor) CXType;
pub extern fn clang_getEnumDeclIntegerType(C: CXCursor) CXType;
pub extern fn clang_getEnumConstantDeclValue(C: CXCursor) c_longlong;
pub extern fn clang_getEnumConstantDeclUnsignedValue(C: CXCursor) c_ulonglong;
pub extern fn clang_Cursor_isBitField(C: CXCursor) c_uint;
pub extern fn clang_getFieldDeclBitWidth(C: CXCursor) c_int;
pub extern fn clang_Cursor_getNumArguments(C: CXCursor) c_int;
pub extern fn clang_Cursor_getArgument(C: CXCursor, i: c_uint) CXCursor;
pub const CXTemplateArgumentKind_Null: c_int = 0;
pub const CXTemplateArgumentKind_Type: c_int = 1;
pub const CXTemplateArgumentKind_Declaration: c_int = 2;
pub const CXTemplateArgumentKind_NullPtr: c_int = 3;
pub const CXTemplateArgumentKind_Integral: c_int = 4;
pub const CXTemplateArgumentKind_Template: c_int = 5;
pub const CXTemplateArgumentKind_TemplateExpansion: c_int = 6;
pub const CXTemplateArgumentKind_Expression: c_int = 7;
pub const CXTemplateArgumentKind_Pack: c_int = 8;
pub const CXTemplateArgumentKind_Invalid: c_int = 9;
pub const enum_CXTemplateArgumentKind = c_uint;
pub extern fn clang_Cursor_getNumTemplateArguments(C: CXCursor) c_int;
pub extern fn clang_Cursor_getTemplateArgumentKind(C: CXCursor, I: c_uint) enum_CXTemplateArgumentKind;
pub extern fn clang_Cursor_getTemplateArgumentType(C: CXCursor, I: c_uint) CXType;
pub extern fn clang_Cursor_getTemplateArgumentValue(C: CXCursor, I: c_uint) c_longlong;
pub extern fn clang_Cursor_getTemplateArgumentUnsignedValue(C: CXCursor, I: c_uint) c_ulonglong;
pub extern fn clang_equalTypes(A: CXType, B: CXType) c_uint;
pub extern fn clang_getCanonicalType(T: CXType) CXType;
pub extern fn clang_isConstQualifiedType(T: CXType) c_uint;
pub extern fn clang_Cursor_isMacroFunctionLike(C: CXCursor) c_uint;
pub extern fn clang_Cursor_isMacroBuiltin(C: CXCursor) c_uint;
pub extern fn clang_Cursor_isFunctionInlined(C: CXCursor) c_uint;
pub extern fn clang_isVolatileQualifiedType(T: CXType) c_uint;
pub extern fn clang_isRestrictQualifiedType(T: CXType) c_uint;
pub extern fn clang_getAddressSpace(T: CXType) c_uint;
pub extern fn clang_getTypedefName(CT: CXType) CXString;
pub extern fn clang_getPointeeType(T: CXType) CXType;
pub extern fn clang_getUnqualifiedType(CT: CXType) CXType;
pub extern fn clang_getNonReferenceType(CT: CXType) CXType;
pub extern fn clang_getTypeDeclaration(T: CXType) CXCursor;
pub extern fn clang_getDeclObjCTypeEncoding(C: CXCursor) CXString;
pub extern fn clang_Type_getObjCEncoding(@"type": CXType) CXString;
pub extern fn clang_getTypeKindSpelling(K: enum_CXTypeKind) CXString;
pub extern fn clang_getFunctionTypeCallingConv(T: CXType) enum_CXCallingConv;
pub extern fn clang_getResultType(T: CXType) CXType;
pub extern fn clang_getExceptionSpecificationType(T: CXType) c_int;
pub extern fn clang_getNumArgTypes(T: CXType) c_int;
pub extern fn clang_getArgType(T: CXType, i: c_uint) CXType;
pub extern fn clang_Type_getObjCObjectBaseType(T: CXType) CXType;
pub extern fn clang_Type_getNumObjCProtocolRefs(T: CXType) c_uint;
pub extern fn clang_Type_getObjCProtocolDecl(T: CXType, i: c_uint) CXCursor;
pub extern fn clang_Type_getNumObjCTypeArgs(T: CXType) c_uint;
pub extern fn clang_Type_getObjCTypeArg(T: CXType, i: c_uint) CXType;
pub extern fn clang_isFunctionTypeVariadic(T: CXType) c_uint;
pub extern fn clang_getCursorResultType(C: CXCursor) CXType;
pub extern fn clang_getCursorExceptionSpecificationType(C: CXCursor) c_int;
pub extern fn clang_isPODType(T: CXType) c_uint;
pub extern fn clang_getElementType(T: CXType) CXType;
pub extern fn clang_getNumElements(T: CXType) c_longlong;
pub extern fn clang_getArrayElementType(T: CXType) CXType;
pub extern fn clang_getArraySize(T: CXType) c_longlong;
pub extern fn clang_Type_getNamedType(T: CXType) CXType;
pub extern fn clang_Type_isTransparentTagTypedef(T: CXType) c_uint;
pub const CXTypeNullability_NonNull: c_int = 0;
pub const CXTypeNullability_Nullable: c_int = 1;
pub const CXTypeNullability_Unspecified: c_int = 2;
pub const CXTypeNullability_Invalid: c_int = 3;
pub const CXTypeNullability_NullableResult: c_int = 4;
pub const enum_CXTypeNullabilityKind = c_uint;
pub extern fn clang_Type_getNullability(T: CXType) enum_CXTypeNullabilityKind;
pub const CXTypeLayoutError_Invalid: c_int = -1;
pub const CXTypeLayoutError_Incomplete: c_int = -2;
pub const CXTypeLayoutError_Dependent: c_int = -3;
pub const CXTypeLayoutError_NotConstantSize: c_int = -4;
pub const CXTypeLayoutError_InvalidFieldName: c_int = -5;
pub const CXTypeLayoutError_Undeduced: c_int = -6;
pub const enum_CXTypeLayoutError = c_int;
pub extern fn clang_Type_getAlignOf(T: CXType) c_longlong;
pub extern fn clang_Type_getClassType(T: CXType) CXType;
pub extern fn clang_Type_getSizeOf(T: CXType) c_longlong;
pub extern fn clang_Type_getOffsetOf(T: CXType, S: [*c]const u8) c_longlong;
pub extern fn clang_Type_getModifiedType(T: CXType) CXType;
pub extern fn clang_Type_getValueType(CT: CXType) CXType;
pub extern fn clang_Cursor_getOffsetOfField(C: CXCursor) c_longlong;
pub extern fn clang_Cursor_isAnonymous(C: CXCursor) c_uint;
pub extern fn clang_Cursor_isAnonymousRecordDecl(C: CXCursor) c_uint;
pub extern fn clang_Cursor_isInlineNamespace(C: CXCursor) c_uint;
pub const CXRefQualifier_None: c_int = 0;
pub const CXRefQualifier_LValue: c_int = 1;
pub const CXRefQualifier_RValue: c_int = 2;
pub const enum_CXRefQualifierKind = c_uint;
pub extern fn clang_Type_getNumTemplateArguments(T: CXType) c_int;
pub extern fn clang_Type_getTemplateArgumentAsType(T: CXType, i: c_uint) CXType;
pub extern fn clang_Type_getCXXRefQualifier(T: CXType) enum_CXRefQualifierKind;
pub extern fn clang_isVirtualBase(CXCursor) c_uint;
pub const CX_CXXInvalidAccessSpecifier: c_int = 0;
pub const CX_CXXPublic: c_int = 1;
pub const CX_CXXProtected: c_int = 2;
pub const CX_CXXPrivate: c_int = 3;
pub const enum_CX_CXXAccessSpecifier = c_uint;
pub extern fn clang_getCXXAccessSpecifier(CXCursor) enum_CX_CXXAccessSpecifier;
pub const CX_SC_Invalid: c_int = 0;
pub const CX_SC_None: c_int = 1;
pub const CX_SC_Extern: c_int = 2;
pub const CX_SC_Static: c_int = 3;
pub const CX_SC_PrivateExtern: c_int = 4;
pub const CX_SC_OpenCLWorkGroupLocal: c_int = 5;
pub const CX_SC_Auto: c_int = 6;
pub const CX_SC_Register: c_int = 7;
pub const enum_CX_StorageClass = c_uint;
pub extern fn clang_Cursor_getStorageClass(CXCursor) enum_CX_StorageClass;
pub extern fn clang_getNumOverloadedDecls(cursor: CXCursor) c_uint;
pub extern fn clang_getOverloadedDecl(cursor: CXCursor, index: c_uint) CXCursor;
pub extern fn clang_getIBOutletCollectionType(CXCursor) CXType;
pub const CXChildVisit_Break: c_int = 0;
pub const CXChildVisit_Continue: c_int = 1;
pub const CXChildVisit_Recurse: c_int = 2;
pub const enum_CXChildVisitResult = c_uint;
pub const CXCursorVisitor = ?*const fn (CXCursor, CXCursor, CXClientData) callconv(.C) enum_CXChildVisitResult;
pub extern fn clang_visitChildren(parent: CXCursor, visitor: CXCursorVisitor, client_data: CXClientData) c_uint;
pub const struct__CXChildVisitResult = opaque {};
pub const CXCursorVisitorBlock = ?*struct__CXChildVisitResult;
pub extern fn clang_visitChildrenWithBlock(parent: CXCursor, block: CXCursorVisitorBlock) c_uint;
pub extern fn clang_getCursorUSR(CXCursor) CXString;
pub extern fn clang_constructUSR_ObjCClass(class_name: [*c]const u8) CXString;
pub extern fn clang_constructUSR_ObjCCategory(class_name: [*c]const u8, category_name: [*c]const u8) CXString;
pub extern fn clang_constructUSR_ObjCProtocol(protocol_name: [*c]const u8) CXString;
pub extern fn clang_constructUSR_ObjCIvar(name: [*c]const u8, classUSR: CXString) CXString;
pub extern fn clang_constructUSR_ObjCMethod(name: [*c]const u8, isInstanceMethod: c_uint, classUSR: CXString) CXString;
pub extern fn clang_constructUSR_ObjCProperty(property: [*c]const u8, classUSR: CXString) CXString;
pub extern fn clang_getCursorSpelling(CXCursor) CXString;
pub extern fn clang_Cursor_getSpellingNameRange(CXCursor, pieceIndex: c_uint, options: c_uint) CXSourceRange;
pub const CXPrintingPolicy = ?*anyopaque;
pub const CXPrintingPolicy_Indentation: c_int = 0;
pub const CXPrintingPolicy_SuppressSpecifiers: c_int = 1;
pub const CXPrintingPolicy_SuppressTagKeyword: c_int = 2;
pub const CXPrintingPolicy_IncludeTagDefinition: c_int = 3;
pub const CXPrintingPolicy_SuppressScope: c_int = 4;
pub const CXPrintingPolicy_SuppressUnwrittenScope: c_int = 5;
pub const CXPrintingPolicy_SuppressInitializers: c_int = 6;
pub const CXPrintingPolicy_ConstantArraySizeAsWritten: c_int = 7;
pub const CXPrintingPolicy_AnonymousTagLocations: c_int = 8;
pub const CXPrintingPolicy_SuppressStrongLifetime: c_int = 9;
pub const CXPrintingPolicy_SuppressLifetimeQualifiers: c_int = 10;
pub const CXPrintingPolicy_SuppressTemplateArgsInCXXConstructors: c_int = 11;
pub const CXPrintingPolicy_Bool: c_int = 12;
pub const CXPrintingPolicy_Restrict: c_int = 13;
pub const CXPrintingPolicy_Alignof: c_int = 14;
pub const CXPrintingPolicy_UnderscoreAlignof: c_int = 15;
pub const CXPrintingPolicy_UseVoidForZeroParams: c_int = 16;
pub const CXPrintingPolicy_TerseOutput: c_int = 17;
pub const CXPrintingPolicy_PolishForDeclaration: c_int = 18;
pub const CXPrintingPolicy_Half: c_int = 19;
pub const CXPrintingPolicy_MSWChar: c_int = 20;
pub const CXPrintingPolicy_IncludeNewlines: c_int = 21;
pub const CXPrintingPolicy_MSVCFormatting: c_int = 22;
pub const CXPrintingPolicy_ConstantsAsWritten: c_int = 23;
pub const CXPrintingPolicy_SuppressImplicitBase: c_int = 24;
pub const CXPrintingPolicy_FullyQualifiedName: c_int = 25;
pub const CXPrintingPolicy_LastProperty: c_int = 25;
pub const enum_CXPrintingPolicyProperty = c_uint;
pub extern fn clang_PrintingPolicy_getProperty(Policy: CXPrintingPolicy, Property: enum_CXPrintingPolicyProperty) c_uint;
pub extern fn clang_PrintingPolicy_setProperty(Policy: CXPrintingPolicy, Property: enum_CXPrintingPolicyProperty, Value: c_uint) void;
pub extern fn clang_getCursorPrintingPolicy(CXCursor) CXPrintingPolicy;
pub extern fn clang_PrintingPolicy_dispose(Policy: CXPrintingPolicy) void;
pub extern fn clang_getCursorPrettyPrinted(Cursor: CXCursor, Policy: CXPrintingPolicy) CXString;
pub extern fn clang_getCursorDisplayName(CXCursor) CXString;
pub extern fn clang_getCursorReferenced(CXCursor) CXCursor;
pub extern fn clang_getCursorDefinition(CXCursor) CXCursor;
pub extern fn clang_isCursorDefinition(CXCursor) c_uint;
pub extern fn clang_getCanonicalCursor(CXCursor) CXCursor;
pub extern fn clang_Cursor_getObjCSelectorIndex(CXCursor) c_int;
pub extern fn clang_Cursor_isDynamicCall(C: CXCursor) c_int;
pub extern fn clang_Cursor_getReceiverType(C: CXCursor) CXType;
pub const CXObjCPropertyAttr_noattr: c_int = 0;
pub const CXObjCPropertyAttr_readonly: c_int = 1;
pub const CXObjCPropertyAttr_getter: c_int = 2;
pub const CXObjCPropertyAttr_assign: c_int = 4;
pub const CXObjCPropertyAttr_readwrite: c_int = 8;
pub const CXObjCPropertyAttr_retain: c_int = 16;
pub const CXObjCPropertyAttr_copy: c_int = 32;
pub const CXObjCPropertyAttr_nonatomic: c_int = 64;
pub const CXObjCPropertyAttr_setter: c_int = 128;
pub const CXObjCPropertyAttr_atomic: c_int = 256;
pub const CXObjCPropertyAttr_weak: c_int = 512;
pub const CXObjCPropertyAttr_strong: c_int = 1024;
pub const CXObjCPropertyAttr_unsafe_unretained: c_int = 2048;
pub const CXObjCPropertyAttr_class: c_int = 4096;
pub const CXObjCPropertyAttrKind = c_uint;
pub extern fn clang_Cursor_getObjCPropertyAttributes(C: CXCursor, reserved: c_uint) c_uint;
pub extern fn clang_Cursor_getObjCPropertyGetterName(C: CXCursor) CXString;
pub extern fn clang_Cursor_getObjCPropertySetterName(C: CXCursor) CXString;
pub const CXObjCDeclQualifier_None: c_int = 0;
pub const CXObjCDeclQualifier_In: c_int = 1;
pub const CXObjCDeclQualifier_Inout: c_int = 2;
pub const CXObjCDeclQualifier_Out: c_int = 4;
pub const CXObjCDeclQualifier_Bycopy: c_int = 8;
pub const CXObjCDeclQualifier_Byref: c_int = 16;
pub const CXObjCDeclQualifier_Oneway: c_int = 32;
pub const CXObjCDeclQualifierKind = c_uint;
pub extern fn clang_Cursor_getObjCDeclQualifiers(C: CXCursor) c_uint;
pub extern fn clang_Cursor_isObjCOptional(C: CXCursor) c_uint;
pub extern fn clang_Cursor_isVariadic(C: CXCursor) c_uint;
pub extern fn clang_Cursor_isExternalSymbol(C: CXCursor, language: [*c]CXString, definedIn: [*c]CXString, isGenerated: [*c]c_uint) c_uint;
pub extern fn clang_Cursor_getCommentRange(C: CXCursor) CXSourceRange;
pub extern fn clang_Cursor_getRawCommentText(C: CXCursor) CXString;
pub extern fn clang_Cursor_getBriefCommentText(C: CXCursor) CXString;
pub extern fn clang_Cursor_getMangling(CXCursor) CXString;
pub extern fn clang_Cursor_getCXXManglings(CXCursor) [*c]CXStringSet;
pub extern fn clang_Cursor_getObjCManglings(CXCursor) [*c]CXStringSet;
pub const CXModule = ?*anyopaque;
pub extern fn clang_Cursor_getModule(C: CXCursor) CXModule;
pub extern fn clang_getModuleForFile(CXTranslationUnit, CXFile) CXModule;
pub extern fn clang_Module_getASTFile(Module: CXModule) CXFile;
pub extern fn clang_Module_getParent(Module: CXModule) CXModule;
pub extern fn clang_Module_getName(Module: CXModule) CXString;
pub extern fn clang_Module_getFullName(Module: CXModule) CXString;
pub extern fn clang_Module_isSystem(Module: CXModule) c_int;
pub extern fn clang_Module_getNumTopLevelHeaders(CXTranslationUnit, Module: CXModule) c_uint;
pub extern fn clang_Module_getTopLevelHeader(CXTranslationUnit, Module: CXModule, Index: c_uint) CXFile;
pub extern fn clang_CXXConstructor_isConvertingConstructor(C: CXCursor) c_uint;
pub extern fn clang_CXXConstructor_isCopyConstructor(C: CXCursor) c_uint;
pub extern fn clang_CXXConstructor_isDefaultConstructor(C: CXCursor) c_uint;
pub extern fn clang_CXXConstructor_isMoveConstructor(C: CXCursor) c_uint;
pub extern fn clang_CXXField_isMutable(C: CXCursor) c_uint;
pub extern fn clang_CXXMethod_isDefaulted(C: CXCursor) c_uint;
pub extern fn clang_CXXMethod_isDeleted(C: CXCursor) c_uint;
pub extern fn clang_CXXMethod_isPureVirtual(C: CXCursor) c_uint;
pub extern fn clang_CXXMethod_isStatic(C: CXCursor) c_uint;
pub extern fn clang_CXXMethod_isVirtual(C: CXCursor) c_uint;
pub extern fn clang_CXXMethod_isCopyAssignmentOperator(C: CXCursor) c_uint;
pub extern fn clang_CXXMethod_isMoveAssignmentOperator(C: CXCursor) c_uint;
pub extern fn clang_CXXMethod_isExplicit(C: CXCursor) c_uint;
pub extern fn clang_CXXRecord_isAbstract(C: CXCursor) c_uint;
pub extern fn clang_EnumDecl_isScoped(C: CXCursor) c_uint;
pub extern fn clang_CXXMethod_isConst(C: CXCursor) c_uint;
pub extern fn clang_getTemplateCursorKind(C: CXCursor) enum_CXCursorKind;
pub extern fn clang_getSpecializedCursorTemplate(C: CXCursor) CXCursor;
pub extern fn clang_getCursorReferenceNameRange(C: CXCursor, NameFlags: c_uint, PieceIndex: c_uint) CXSourceRange;
pub const CXNameRange_WantQualifier: c_int = 1;
pub const CXNameRange_WantTemplateArgs: c_int = 2;
pub const CXNameRange_WantSinglePiece: c_int = 4;
pub const enum_CXNameRefFlags = c_uint;
pub const CXToken_Punctuation: c_int = 0;
pub const CXToken_Keyword: c_int = 1;
pub const CXToken_Identifier: c_int = 2;
pub const CXToken_Literal: c_int = 3;
pub const CXToken_Comment: c_int = 4;
pub const enum_CXTokenKind = c_uint;
pub const CXTokenKind = enum_CXTokenKind;
pub const CXToken = extern struct {
    int_data: [4]c_uint = @import("std").mem.zeroes([4]c_uint),
    ptr_data: ?*anyopaque = @import("std").mem.zeroes(?*anyopaque),
};
pub extern fn clang_getToken(TU: CXTranslationUnit, Location: CXSourceLocation) [*c]CXToken;
pub extern fn clang_getTokenKind(CXToken) CXTokenKind;
pub extern fn clang_getTokenSpelling(CXTranslationUnit, CXToken) CXString;
pub extern fn clang_getTokenLocation(CXTranslationUnit, CXToken) CXSourceLocation;
pub extern fn clang_getTokenExtent(CXTranslationUnit, CXToken) CXSourceRange;
pub extern fn clang_tokenize(TU: CXTranslationUnit, Range: CXSourceRange, Tokens: [*c][*c]CXToken, NumTokens: [*c]c_uint) void;
pub extern fn clang_annotateTokens(TU: CXTranslationUnit, Tokens: [*c]CXToken, NumTokens: c_uint, Cursors: [*c]CXCursor) void;
pub extern fn clang_disposeTokens(TU: CXTranslationUnit, Tokens: [*c]CXToken, NumTokens: c_uint) void;
pub extern fn clang_getCursorKindSpelling(Kind: enum_CXCursorKind) CXString;
pub extern fn clang_getDefinitionSpellingAndExtent(CXCursor, startBuf: [*c][*c]const u8, endBuf: [*c][*c]const u8, startLine: [*c]c_uint, startColumn: [*c]c_uint, endLine: [*c]c_uint, endColumn: [*c]c_uint) void;
pub extern fn clang_enableStackTraces() void;
pub extern fn clang_executeOnThread(@"fn": ?*const fn (?*anyopaque) callconv(.C) void, user_data: ?*anyopaque, stack_size: c_uint) void;
pub const CXCompletionString = ?*anyopaque;
pub const CXCompletionResult = extern struct {
    CursorKind: enum_CXCursorKind = @import("std").mem.zeroes(enum_CXCursorKind),
    CompletionString: CXCompletionString = @import("std").mem.zeroes(CXCompletionString),
};
pub const CXCompletionChunk_Optional: c_int = 0;
pub const CXCompletionChunk_TypedText: c_int = 1;
pub const CXCompletionChunk_Text: c_int = 2;
pub const CXCompletionChunk_Placeholder: c_int = 3;
pub const CXCompletionChunk_Informative: c_int = 4;
pub const CXCompletionChunk_CurrentParameter: c_int = 5;
pub const CXCompletionChunk_LeftParen: c_int = 6;
pub const CXCompletionChunk_RightParen: c_int = 7;
pub const CXCompletionChunk_LeftBracket: c_int = 8;
pub const CXCompletionChunk_RightBracket: c_int = 9;
pub const CXCompletionChunk_LeftBrace: c_int = 10;
pub const CXCompletionChunk_RightBrace: c_int = 11;
pub const CXCompletionChunk_LeftAngle: c_int = 12;
pub const CXCompletionChunk_RightAngle: c_int = 13;
pub const CXCompletionChunk_Comma: c_int = 14;
pub const CXCompletionChunk_ResultType: c_int = 15;
pub const CXCompletionChunk_Colon: c_int = 16;
pub const CXCompletionChunk_SemiColon: c_int = 17;
pub const CXCompletionChunk_Equal: c_int = 18;
pub const CXCompletionChunk_HorizontalSpace: c_int = 19;
pub const CXCompletionChunk_VerticalSpace: c_int = 20;
pub const enum_CXCompletionChunkKind = c_uint;
pub extern fn clang_getCompletionChunkKind(completion_string: CXCompletionString, chunk_number: c_uint) enum_CXCompletionChunkKind;
pub extern fn clang_getCompletionChunkText(completion_string: CXCompletionString, chunk_number: c_uint) CXString;
pub extern fn clang_getCompletionChunkCompletionString(completion_string: CXCompletionString, chunk_number: c_uint) CXCompletionString;
pub extern fn clang_getNumCompletionChunks(completion_string: CXCompletionString) c_uint;
pub extern fn clang_getCompletionPriority(completion_string: CXCompletionString) c_uint;
pub extern fn clang_getCompletionAvailability(completion_string: CXCompletionString) enum_CXAvailabilityKind;
pub extern fn clang_getCompletionNumAnnotations(completion_string: CXCompletionString) c_uint;
pub extern fn clang_getCompletionAnnotation(completion_string: CXCompletionString, annotation_number: c_uint) CXString;
pub extern fn clang_getCompletionParent(completion_string: CXCompletionString, kind: [*c]enum_CXCursorKind) CXString;
pub extern fn clang_getCompletionBriefComment(completion_string: CXCompletionString) CXString;
pub extern fn clang_getCursorCompletionString(cursor: CXCursor) CXCompletionString;
pub const CXCodeCompleteResults = extern struct {
    Results: [*c]CXCompletionResult = @import("std").mem.zeroes([*c]CXCompletionResult),
    NumResults: c_uint = @import("std").mem.zeroes(c_uint),
};
pub extern fn clang_getCompletionNumFixIts(results: [*c]CXCodeCompleteResults, completion_index: c_uint) c_uint;
pub extern fn clang_getCompletionFixIt(results: [*c]CXCodeCompleteResults, completion_index: c_uint, fixit_index: c_uint, replacement_range: [*c]CXSourceRange) CXString;
pub const CXCodeComplete_IncludeMacros: c_int = 1;
pub const CXCodeComplete_IncludeCodePatterns: c_int = 2;
pub const CXCodeComplete_IncludeBriefComments: c_int = 4;
pub const CXCodeComplete_SkipPreamble: c_int = 8;
pub const CXCodeComplete_IncludeCompletionsWithFixIts: c_int = 16;
pub const enum_CXCodeComplete_Flags = c_uint;
pub const CXCompletionContext_Unexposed: c_int = 0;
pub const CXCompletionContext_AnyType: c_int = 1;
pub const CXCompletionContext_AnyValue: c_int = 2;
pub const CXCompletionContext_ObjCObjectValue: c_int = 4;
pub const CXCompletionContext_ObjCSelectorValue: c_int = 8;
pub const CXCompletionContext_CXXClassTypeValue: c_int = 16;
pub const CXCompletionContext_DotMemberAccess: c_int = 32;
pub const CXCompletionContext_ArrowMemberAccess: c_int = 64;
pub const CXCompletionContext_ObjCPropertyAccess: c_int = 128;
pub const CXCompletionContext_EnumTag: c_int = 256;
pub const CXCompletionContext_UnionTag: c_int = 512;
pub const CXCompletionContext_StructTag: c_int = 1024;
pub const CXCompletionContext_ClassTag: c_int = 2048;
pub const CXCompletionContext_Namespace: c_int = 4096;
pub const CXCompletionContext_NestedNameSpecifier: c_int = 8192;
pub const CXCompletionContext_ObjCInterface: c_int = 16384;
pub const CXCompletionContext_ObjCProtocol: c_int = 32768;
pub const CXCompletionContext_ObjCCategory: c_int = 65536;
pub const CXCompletionContext_ObjCInstanceMessage: c_int = 131072;
pub const CXCompletionContext_ObjCClassMessage: c_int = 262144;
pub const CXCompletionContext_ObjCSelectorName: c_int = 524288;
pub const CXCompletionContext_MacroName: c_int = 1048576;
pub const CXCompletionContext_NaturalLanguage: c_int = 2097152;
pub const CXCompletionContext_IncludedFile: c_int = 4194304;
pub const CXCompletionContext_Unknown: c_int = 8388607;
pub const enum_CXCompletionContext = c_uint;
pub extern fn clang_defaultCodeCompleteOptions() c_uint;
pub extern fn clang_codeCompleteAt(TU: CXTranslationUnit, complete_filename: [*c]const u8, complete_line: c_uint, complete_column: c_uint, unsaved_files: [*c]struct_CXUnsavedFile, num_unsaved_files: c_uint, options: c_uint) [*c]CXCodeCompleteResults;
pub extern fn clang_sortCodeCompletionResults(Results: [*c]CXCompletionResult, NumResults: c_uint) void;
pub extern fn clang_disposeCodeCompleteResults(Results: [*c]CXCodeCompleteResults) void;
pub extern fn clang_codeCompleteGetNumDiagnostics(Results: [*c]CXCodeCompleteResults) c_uint;
pub extern fn clang_codeCompleteGetDiagnostic(Results: [*c]CXCodeCompleteResults, Index: c_uint) CXDiagnostic;
pub extern fn clang_codeCompleteGetContexts(Results: [*c]CXCodeCompleteResults) c_ulonglong;
pub extern fn clang_codeCompleteGetContainerKind(Results: [*c]CXCodeCompleteResults, IsIncomplete: [*c]c_uint) enum_CXCursorKind;
pub extern fn clang_codeCompleteGetContainerUSR(Results: [*c]CXCodeCompleteResults) CXString;
pub extern fn clang_codeCompleteGetObjCSelector(Results: [*c]CXCodeCompleteResults) CXString;
pub extern fn clang_getClangVersion() CXString;
pub extern fn clang_toggleCrashRecovery(isEnabled: c_uint) void;
pub const CXInclusionVisitor = ?*const fn (CXFile, [*c]CXSourceLocation, c_uint, CXClientData) callconv(.C) void;
pub extern fn clang_getInclusions(tu: CXTranslationUnit, visitor: CXInclusionVisitor, client_data: CXClientData) void;
pub const CXEval_Int: c_int = 1;
pub const CXEval_Float: c_int = 2;
pub const CXEval_ObjCStrLiteral: c_int = 3;
pub const CXEval_StrLiteral: c_int = 4;
pub const CXEval_CFStr: c_int = 5;
pub const CXEval_Other: c_int = 6;
pub const CXEval_UnExposed: c_int = 0;
pub const CXEvalResultKind = c_uint;
pub const CXEvalResult = ?*anyopaque;
pub extern fn clang_Cursor_Evaluate(C: CXCursor) CXEvalResult;
pub extern fn clang_EvalResult_getKind(E: CXEvalResult) CXEvalResultKind;
pub extern fn clang_EvalResult_getAsInt(E: CXEvalResult) c_int;
pub extern fn clang_EvalResult_getAsLongLong(E: CXEvalResult) c_longlong;
pub extern fn clang_EvalResult_isUnsignedInt(E: CXEvalResult) c_uint;
pub extern fn clang_EvalResult_getAsUnsigned(E: CXEvalResult) c_ulonglong;
pub extern fn clang_EvalResult_getAsDouble(E: CXEvalResult) f64;
pub extern fn clang_EvalResult_getAsStr(E: CXEvalResult) [*c]const u8;
pub extern fn clang_EvalResult_dispose(E: CXEvalResult) void;
pub const CXRemapping = ?*anyopaque;
pub extern fn clang_getRemappings(path: [*c]const u8) CXRemapping;
pub extern fn clang_getRemappingsFromFileList(filePaths: [*c][*c]const u8, numFiles: c_uint) CXRemapping;
pub extern fn clang_remap_getNumFiles(CXRemapping) c_uint;
pub extern fn clang_remap_getFilenames(CXRemapping, index: c_uint, original: [*c]CXString, transformed: [*c]CXString) void;
pub extern fn clang_remap_dispose(CXRemapping) void;
pub const CXVisit_Break: c_int = 0;
pub const CXVisit_Continue: c_int = 1;
pub const enum_CXVisitorResult = c_uint;
pub const struct_CXCursorAndRangeVisitor = extern struct {
    context: ?*anyopaque = @import("std").mem.zeroes(?*anyopaque),
    visit: ?*const fn (?*anyopaque, CXCursor, CXSourceRange) callconv(.C) enum_CXVisitorResult = @import("std").mem.zeroes(?*const fn (?*anyopaque, CXCursor, CXSourceRange) callconv(.C) enum_CXVisitorResult),
};
pub const CXCursorAndRangeVisitor = struct_CXCursorAndRangeVisitor;
pub const CXResult_Success: c_int = 0;
pub const CXResult_Invalid: c_int = 1;
pub const CXResult_VisitBreak: c_int = 2;
pub const CXResult = c_uint;
pub extern fn clang_findReferencesInFile(cursor: CXCursor, file: CXFile, visitor: CXCursorAndRangeVisitor) CXResult;
pub extern fn clang_findIncludesInFile(TU: CXTranslationUnit, file: CXFile, visitor: CXCursorAndRangeVisitor) CXResult;
pub const struct__CXCursorAndRangeVisitorBlock = opaque {};
pub const CXCursorAndRangeVisitorBlock = ?*struct__CXCursorAndRangeVisitorBlock;
pub extern fn clang_findReferencesInFileWithBlock(CXCursor, CXFile, CXCursorAndRangeVisitorBlock) CXResult;
pub extern fn clang_findIncludesInFileWithBlock(CXTranslationUnit, CXFile, CXCursorAndRangeVisitorBlock) CXResult;
pub const CXIdxClientFile = ?*anyopaque;
pub const CXIdxClientEntity = ?*anyopaque;
pub const CXIdxClientContainer = ?*anyopaque;
pub const CXIdxClientASTFile = ?*anyopaque;
pub const CXIdxLoc = extern struct {
    ptr_data: [2]?*anyopaque = @import("std").mem.zeroes([2]?*anyopaque),
    int_data: c_uint = @import("std").mem.zeroes(c_uint),
};
pub const CXIdxIncludedFileInfo = extern struct {
    hashLoc: CXIdxLoc = @import("std").mem.zeroes(CXIdxLoc),
    filename: [*c]const u8 = @import("std").mem.zeroes([*c]const u8),
    file: CXFile = @import("std").mem.zeroes(CXFile),
    isImport: c_int = @import("std").mem.zeroes(c_int),
    isAngled: c_int = @import("std").mem.zeroes(c_int),
    isModuleImport: c_int = @import("std").mem.zeroes(c_int),
};
pub const CXIdxImportedASTFileInfo = extern struct {
    file: CXFile = @import("std").mem.zeroes(CXFile),
    module: CXModule = @import("std").mem.zeroes(CXModule),
    loc: CXIdxLoc = @import("std").mem.zeroes(CXIdxLoc),
    isImplicit: c_int = @import("std").mem.zeroes(c_int),
};
pub const CXIdxEntity_Unexposed: c_int = 0;
pub const CXIdxEntity_Typedef: c_int = 1;
pub const CXIdxEntity_Function: c_int = 2;
pub const CXIdxEntity_Variable: c_int = 3;
pub const CXIdxEntity_Field: c_int = 4;
pub const CXIdxEntity_EnumConstant: c_int = 5;
pub const CXIdxEntity_ObjCClass: c_int = 6;
pub const CXIdxEntity_ObjCProtocol: c_int = 7;
pub const CXIdxEntity_ObjCCategory: c_int = 8;
pub const CXIdxEntity_ObjCInstanceMethod: c_int = 9;
pub const CXIdxEntity_ObjCClassMethod: c_int = 10;
pub const CXIdxEntity_ObjCProperty: c_int = 11;
pub const CXIdxEntity_ObjCIvar: c_int = 12;
pub const CXIdxEntity_Enum: c_int = 13;
pub const CXIdxEntity_Struct: c_int = 14;
pub const CXIdxEntity_Union: c_int = 15;
pub const CXIdxEntity_CXXClass: c_int = 16;
pub const CXIdxEntity_CXXNamespace: c_int = 17;
pub const CXIdxEntity_CXXNamespaceAlias: c_int = 18;
pub const CXIdxEntity_CXXStaticVariable: c_int = 19;
pub const CXIdxEntity_CXXStaticMethod: c_int = 20;
pub const CXIdxEntity_CXXInstanceMethod: c_int = 21;
pub const CXIdxEntity_CXXConstructor: c_int = 22;
pub const CXIdxEntity_CXXDestructor: c_int = 23;
pub const CXIdxEntity_CXXConversionFunction: c_int = 24;
pub const CXIdxEntity_CXXTypeAlias: c_int = 25;
pub const CXIdxEntity_CXXInterface: c_int = 26;
pub const CXIdxEntity_CXXConcept: c_int = 27;
pub const CXIdxEntityKind = c_uint;
pub const CXIdxEntityLang_None: c_int = 0;
pub const CXIdxEntityLang_C: c_int = 1;
pub const CXIdxEntityLang_ObjC: c_int = 2;
pub const CXIdxEntityLang_CXX: c_int = 3;
pub const CXIdxEntityLang_Swift: c_int = 4;
pub const CXIdxEntityLanguage = c_uint;
pub const CXIdxEntity_NonTemplate: c_int = 0;
pub const CXIdxEntity_Template: c_int = 1;
pub const CXIdxEntity_TemplatePartialSpecialization: c_int = 2;
pub const CXIdxEntity_TemplateSpecialization: c_int = 3;
pub const CXIdxEntityCXXTemplateKind = c_uint;
pub const CXIdxAttr_Unexposed: c_int = 0;
pub const CXIdxAttr_IBAction: c_int = 1;
pub const CXIdxAttr_IBOutlet: c_int = 2;
pub const CXIdxAttr_IBOutletCollection: c_int = 3;
pub const CXIdxAttrKind = c_uint;
pub const CXIdxAttrInfo = extern struct {
    kind: CXIdxAttrKind = @import("std").mem.zeroes(CXIdxAttrKind),
    cursor: CXCursor = @import("std").mem.zeroes(CXCursor),
    loc: CXIdxLoc = @import("std").mem.zeroes(CXIdxLoc),
};
pub const CXIdxEntityInfo = extern struct {
    kind: CXIdxEntityKind = @import("std").mem.zeroes(CXIdxEntityKind),
    templateKind: CXIdxEntityCXXTemplateKind = @import("std").mem.zeroes(CXIdxEntityCXXTemplateKind),
    lang: CXIdxEntityLanguage = @import("std").mem.zeroes(CXIdxEntityLanguage),
    name: [*c]const u8 = @import("std").mem.zeroes([*c]const u8),
    USR: [*c]const u8 = @import("std").mem.zeroes([*c]const u8),
    cursor: CXCursor = @import("std").mem.zeroes(CXCursor),
    attributes: [*c]const [*c]const CXIdxAttrInfo = @import("std").mem.zeroes([*c]const [*c]const CXIdxAttrInfo),
    numAttributes: c_uint = @import("std").mem.zeroes(c_uint),
};
pub const CXIdxContainerInfo = extern struct {
    cursor: CXCursor = @import("std").mem.zeroes(CXCursor),
};
pub const CXIdxIBOutletCollectionAttrInfo = extern struct {
    attrInfo: [*c]const CXIdxAttrInfo = @import("std").mem.zeroes([*c]const CXIdxAttrInfo),
    objcClass: [*c]const CXIdxEntityInfo = @import("std").mem.zeroes([*c]const CXIdxEntityInfo),
    classCursor: CXCursor = @import("std").mem.zeroes(CXCursor),
    classLoc: CXIdxLoc = @import("std").mem.zeroes(CXIdxLoc),
};
pub const CXIdxDeclFlag_Skipped: c_int = 1;
pub const CXIdxDeclInfoFlags = c_uint;
pub const CXIdxDeclInfo = extern struct {
    entityInfo: [*c]const CXIdxEntityInfo = @import("std").mem.zeroes([*c]const CXIdxEntityInfo),
    cursor: CXCursor = @import("std").mem.zeroes(CXCursor),
    loc: CXIdxLoc = @import("std").mem.zeroes(CXIdxLoc),
    semanticContainer: [*c]const CXIdxContainerInfo = @import("std").mem.zeroes([*c]const CXIdxContainerInfo),
    lexicalContainer: [*c]const CXIdxContainerInfo = @import("std").mem.zeroes([*c]const CXIdxContainerInfo),
    isRedeclaration: c_int = @import("std").mem.zeroes(c_int),
    isDefinition: c_int = @import("std").mem.zeroes(c_int),
    isContainer: c_int = @import("std").mem.zeroes(c_int),
    declAsContainer: [*c]const CXIdxContainerInfo = @import("std").mem.zeroes([*c]const CXIdxContainerInfo),
    isImplicit: c_int = @import("std").mem.zeroes(c_int),
    attributes: [*c]const [*c]const CXIdxAttrInfo = @import("std").mem.zeroes([*c]const [*c]const CXIdxAttrInfo),
    numAttributes: c_uint = @import("std").mem.zeroes(c_uint),
    flags: c_uint = @import("std").mem.zeroes(c_uint),
};
pub const CXIdxObjCContainer_ForwardRef: c_int = 0;
pub const CXIdxObjCContainer_Interface: c_int = 1;
pub const CXIdxObjCContainer_Implementation: c_int = 2;
pub const CXIdxObjCContainerKind = c_uint;
pub const CXIdxObjCContainerDeclInfo = extern struct {
    declInfo: [*c]const CXIdxDeclInfo = @import("std").mem.zeroes([*c]const CXIdxDeclInfo),
    kind: CXIdxObjCContainerKind = @import("std").mem.zeroes(CXIdxObjCContainerKind),
};
pub const CXIdxBaseClassInfo = extern struct {
    base: [*c]const CXIdxEntityInfo = @import("std").mem.zeroes([*c]const CXIdxEntityInfo),
    cursor: CXCursor = @import("std").mem.zeroes(CXCursor),
    loc: CXIdxLoc = @import("std").mem.zeroes(CXIdxLoc),
};
pub const CXIdxObjCProtocolRefInfo = extern struct {
    protocol: [*c]const CXIdxEntityInfo = @import("std").mem.zeroes([*c]const CXIdxEntityInfo),
    cursor: CXCursor = @import("std").mem.zeroes(CXCursor),
    loc: CXIdxLoc = @import("std").mem.zeroes(CXIdxLoc),
};
pub const CXIdxObjCProtocolRefListInfo = extern struct {
    protocols: [*c]const [*c]const CXIdxObjCProtocolRefInfo = @import("std").mem.zeroes([*c]const [*c]const CXIdxObjCProtocolRefInfo),
    numProtocols: c_uint = @import("std").mem.zeroes(c_uint),
};
pub const CXIdxObjCInterfaceDeclInfo = extern struct {
    containerInfo: [*c]const CXIdxObjCContainerDeclInfo = @import("std").mem.zeroes([*c]const CXIdxObjCContainerDeclInfo),
    superInfo: [*c]const CXIdxBaseClassInfo = @import("std").mem.zeroes([*c]const CXIdxBaseClassInfo),
    protocols: [*c]const CXIdxObjCProtocolRefListInfo = @import("std").mem.zeroes([*c]const CXIdxObjCProtocolRefListInfo),
};
pub const CXIdxObjCCategoryDeclInfo = extern struct {
    containerInfo: [*c]const CXIdxObjCContainerDeclInfo = @import("std").mem.zeroes([*c]const CXIdxObjCContainerDeclInfo),
    objcClass: [*c]const CXIdxEntityInfo = @import("std").mem.zeroes([*c]const CXIdxEntityInfo),
    classCursor: CXCursor = @import("std").mem.zeroes(CXCursor),
    classLoc: CXIdxLoc = @import("std").mem.zeroes(CXIdxLoc),
    protocols: [*c]const CXIdxObjCProtocolRefListInfo = @import("std").mem.zeroes([*c]const CXIdxObjCProtocolRefListInfo),
};
pub const CXIdxObjCPropertyDeclInfo = extern struct {
    declInfo: [*c]const CXIdxDeclInfo = @import("std").mem.zeroes([*c]const CXIdxDeclInfo),
    getter: [*c]const CXIdxEntityInfo = @import("std").mem.zeroes([*c]const CXIdxEntityInfo),
    setter: [*c]const CXIdxEntityInfo = @import("std").mem.zeroes([*c]const CXIdxEntityInfo),
};
pub const CXIdxCXXClassDeclInfo = extern struct {
    declInfo: [*c]const CXIdxDeclInfo = @import("std").mem.zeroes([*c]const CXIdxDeclInfo),
    bases: [*c]const [*c]const CXIdxBaseClassInfo = @import("std").mem.zeroes([*c]const [*c]const CXIdxBaseClassInfo),
    numBases: c_uint = @import("std").mem.zeroes(c_uint),
};
pub const CXIdxEntityRef_Direct: c_int = 1;
pub const CXIdxEntityRef_Implicit: c_int = 2;
pub const CXIdxEntityRefKind = c_uint;
pub const CXSymbolRole_None: c_int = 0;
pub const CXSymbolRole_Declaration: c_int = 1;
pub const CXSymbolRole_Definition: c_int = 2;
pub const CXSymbolRole_Reference: c_int = 4;
pub const CXSymbolRole_Read: c_int = 8;
pub const CXSymbolRole_Write: c_int = 16;
pub const CXSymbolRole_Call: c_int = 32;
pub const CXSymbolRole_Dynamic: c_int = 64;
pub const CXSymbolRole_AddressOf: c_int = 128;
pub const CXSymbolRole_Implicit: c_int = 256;
pub const CXSymbolRole = c_uint;
pub const CXIdxEntityRefInfo = extern struct {
    kind: CXIdxEntityRefKind = @import("std").mem.zeroes(CXIdxEntityRefKind),
    cursor: CXCursor = @import("std").mem.zeroes(CXCursor),
    loc: CXIdxLoc = @import("std").mem.zeroes(CXIdxLoc),
    referencedEntity: [*c]const CXIdxEntityInfo = @import("std").mem.zeroes([*c]const CXIdxEntityInfo),
    parentEntity: [*c]const CXIdxEntityInfo = @import("std").mem.zeroes([*c]const CXIdxEntityInfo),
    container: [*c]const CXIdxContainerInfo = @import("std").mem.zeroes([*c]const CXIdxContainerInfo),
    role: CXSymbolRole = @import("std").mem.zeroes(CXSymbolRole),
};
pub const IndexerCallbacks = extern struct {
    abortQuery: ?*const fn (CXClientData, ?*anyopaque) callconv(.C) c_int = @import("std").mem.zeroes(?*const fn (CXClientData, ?*anyopaque) callconv(.C) c_int),
    diagnostic: ?*const fn (CXClientData, CXDiagnosticSet, ?*anyopaque) callconv(.C) void = @import("std").mem.zeroes(?*const fn (CXClientData, CXDiagnosticSet, ?*anyopaque) callconv(.C) void),
    enteredMainFile: ?*const fn (CXClientData, CXFile, ?*anyopaque) callconv(.C) CXIdxClientFile = @import("std").mem.zeroes(?*const fn (CXClientData, CXFile, ?*anyopaque) callconv(.C) CXIdxClientFile),
    ppIncludedFile: ?*const fn (CXClientData, [*c]const CXIdxIncludedFileInfo) callconv(.C) CXIdxClientFile = @import("std").mem.zeroes(?*const fn (CXClientData, [*c]const CXIdxIncludedFileInfo) callconv(.C) CXIdxClientFile),
    importedASTFile: ?*const fn (CXClientData, [*c]const CXIdxImportedASTFileInfo) callconv(.C) CXIdxClientASTFile = @import("std").mem.zeroes(?*const fn (CXClientData, [*c]const CXIdxImportedASTFileInfo) callconv(.C) CXIdxClientASTFile),
    startedTranslationUnit: ?*const fn (CXClientData, ?*anyopaque) callconv(.C) CXIdxClientContainer = @import("std").mem.zeroes(?*const fn (CXClientData, ?*anyopaque) callconv(.C) CXIdxClientContainer),
    indexDeclaration: ?*const fn (CXClientData, [*c]const CXIdxDeclInfo) callconv(.C) void = @import("std").mem.zeroes(?*const fn (CXClientData, [*c]const CXIdxDeclInfo) callconv(.C) void),
    indexEntityReference: ?*const fn (CXClientData, [*c]const CXIdxEntityRefInfo) callconv(.C) void = @import("std").mem.zeroes(?*const fn (CXClientData, [*c]const CXIdxEntityRefInfo) callconv(.C) void),
};
pub extern fn clang_index_isEntityObjCContainerKind(CXIdxEntityKind) c_int;
pub extern fn clang_index_getObjCContainerDeclInfo([*c]const CXIdxDeclInfo) [*c]const CXIdxObjCContainerDeclInfo;
pub extern fn clang_index_getObjCInterfaceDeclInfo([*c]const CXIdxDeclInfo) [*c]const CXIdxObjCInterfaceDeclInfo;
pub extern fn clang_index_getObjCCategoryDeclInfo([*c]const CXIdxDeclInfo) [*c]const CXIdxObjCCategoryDeclInfo;
pub extern fn clang_index_getObjCProtocolRefListInfo([*c]const CXIdxDeclInfo) [*c]const CXIdxObjCProtocolRefListInfo;
pub extern fn clang_index_getObjCPropertyDeclInfo([*c]const CXIdxDeclInfo) [*c]const CXIdxObjCPropertyDeclInfo;
pub extern fn clang_index_getIBOutletCollectionAttrInfo([*c]const CXIdxAttrInfo) [*c]const CXIdxIBOutletCollectionAttrInfo;
pub extern fn clang_index_getCXXClassDeclInfo([*c]const CXIdxDeclInfo) [*c]const CXIdxCXXClassDeclInfo;
pub extern fn clang_index_getClientContainer([*c]const CXIdxContainerInfo) CXIdxClientContainer;
pub extern fn clang_index_setClientContainer([*c]const CXIdxContainerInfo, CXIdxClientContainer) void;
pub extern fn clang_index_getClientEntity([*c]const CXIdxEntityInfo) CXIdxClientEntity;
pub extern fn clang_index_setClientEntity([*c]const CXIdxEntityInfo, CXIdxClientEntity) void;
pub const CXIndexAction = ?*anyopaque;
pub extern fn clang_IndexAction_create(CIdx: CXIndex) CXIndexAction;
pub extern fn clang_IndexAction_dispose(CXIndexAction) void;
pub const CXIndexOpt_None: c_int = 0;
pub const CXIndexOpt_SuppressRedundantRefs: c_int = 1;
pub const CXIndexOpt_IndexFunctionLocalSymbols: c_int = 2;
pub const CXIndexOpt_IndexImplicitTemplateInstantiations: c_int = 4;
pub const CXIndexOpt_SuppressWarnings: c_int = 8;
pub const CXIndexOpt_SkipParsedBodiesInSession: c_int = 16;
pub const CXIndexOptFlags = c_uint;
pub extern fn clang_indexSourceFile(CXIndexAction, client_data: CXClientData, index_callbacks: [*c]IndexerCallbacks, index_callbacks_size: c_uint, index_options: c_uint, source_filename: [*c]const u8, command_line_args: [*c]const [*c]const u8, num_command_line_args: c_int, unsaved_files: [*c]struct_CXUnsavedFile, num_unsaved_files: c_uint, out_TU: [*c]CXTranslationUnit, TU_options: c_uint) c_int;
pub extern fn clang_indexSourceFileFullArgv(CXIndexAction, client_data: CXClientData, index_callbacks: [*c]IndexerCallbacks, index_callbacks_size: c_uint, index_options: c_uint, source_filename: [*c]const u8, command_line_args: [*c]const [*c]const u8, num_command_line_args: c_int, unsaved_files: [*c]struct_CXUnsavedFile, num_unsaved_files: c_uint, out_TU: [*c]CXTranslationUnit, TU_options: c_uint) c_int;
pub extern fn clang_indexTranslationUnit(CXIndexAction, client_data: CXClientData, index_callbacks: [*c]IndexerCallbacks, index_callbacks_size: c_uint, index_options: c_uint, CXTranslationUnit) c_int;
pub extern fn clang_indexLoc_getFileLocation(loc: CXIdxLoc, indexFile: [*c]CXIdxClientFile, file: [*c]CXFile, line: [*c]c_uint, column: [*c]c_uint, offset: [*c]c_uint) void;
pub extern fn clang_indexLoc_getCXSourceLocation(loc: CXIdxLoc) CXSourceLocation;
pub const CXFieldVisitor = ?*const fn (CXCursor, CXClientData) callconv(.C) enum_CXVisitorResult;
pub extern fn clang_Type_visitFields(T: CXType, visitor: CXFieldVisitor, client_data: CXClientData) c_uint;
pub const CXBinaryOperator_Invalid: c_int = 0;
pub const CXBinaryOperator_PtrMemD: c_int = 1;
pub const CXBinaryOperator_PtrMemI: c_int = 2;
pub const CXBinaryOperator_Mul: c_int = 3;
pub const CXBinaryOperator_Div: c_int = 4;
pub const CXBinaryOperator_Rem: c_int = 5;
pub const CXBinaryOperator_Add: c_int = 6;
pub const CXBinaryOperator_Sub: c_int = 7;
pub const CXBinaryOperator_Shl: c_int = 8;
pub const CXBinaryOperator_Shr: c_int = 9;
pub const CXBinaryOperator_Cmp: c_int = 10;
pub const CXBinaryOperator_LT: c_int = 11;
pub const CXBinaryOperator_GT: c_int = 12;
pub const CXBinaryOperator_LE: c_int = 13;
pub const CXBinaryOperator_GE: c_int = 14;
pub const CXBinaryOperator_EQ: c_int = 15;
pub const CXBinaryOperator_NE: c_int = 16;
pub const CXBinaryOperator_And: c_int = 17;
pub const CXBinaryOperator_Xor: c_int = 18;
pub const CXBinaryOperator_Or: c_int = 19;
pub const CXBinaryOperator_LAnd: c_int = 20;
pub const CXBinaryOperator_LOr: c_int = 21;
pub const CXBinaryOperator_Assign: c_int = 22;
pub const CXBinaryOperator_MulAssign: c_int = 23;
pub const CXBinaryOperator_DivAssign: c_int = 24;
pub const CXBinaryOperator_RemAssign: c_int = 25;
pub const CXBinaryOperator_AddAssign: c_int = 26;
pub const CXBinaryOperator_SubAssign: c_int = 27;
pub const CXBinaryOperator_ShlAssign: c_int = 28;
pub const CXBinaryOperator_ShrAssign: c_int = 29;
pub const CXBinaryOperator_AndAssign: c_int = 30;
pub const CXBinaryOperator_XorAssign: c_int = 31;
pub const CXBinaryOperator_OrAssign: c_int = 32;
pub const CXBinaryOperator_Comma: c_int = 33;
pub const enum_CXBinaryOperatorKind = c_uint;
pub extern fn clang_getBinaryOperatorKindSpelling(kind: enum_CXBinaryOperatorKind) CXString;
pub extern fn clang_getCursorBinaryOperatorKind(cursor: CXCursor) enum_CXBinaryOperatorKind;
pub const CXUnaryOperator_Invalid: c_int = 0;
pub const CXUnaryOperator_PostInc: c_int = 1;
pub const CXUnaryOperator_PostDec: c_int = 2;
pub const CXUnaryOperator_PreInc: c_int = 3;
pub const CXUnaryOperator_PreDec: c_int = 4;
pub const CXUnaryOperator_AddrOf: c_int = 5;
pub const CXUnaryOperator_Deref: c_int = 6;
pub const CXUnaryOperator_Plus: c_int = 7;
pub const CXUnaryOperator_Minus: c_int = 8;
pub const CXUnaryOperator_Not: c_int = 9;
pub const CXUnaryOperator_LNot: c_int = 10;
pub const CXUnaryOperator_Real: c_int = 11;
pub const CXUnaryOperator_Imag: c_int = 12;
pub const CXUnaryOperator_Extension: c_int = 13;
pub const CXUnaryOperator_Coawait: c_int = 14;
pub const enum_CXUnaryOperatorKind = c_uint;
pub extern fn clang_getUnaryOperatorKindSpelling(kind: enum_CXUnaryOperatorKind) CXString;
pub extern fn clang_getCursorUnaryOperatorKind(cursor: CXCursor) enum_CXUnaryOperatorKind;
pub const __llvm__ = @as(c_int, 1);
pub const __clang__ = @as(c_int, 1);
pub const __clang_major__ = @as(c_int, 18);
pub const __clang_minor__ = @as(c_int, 1);
pub const __clang_patchlevel__ = @as(c_int, 6);
pub const __clang_version__ = "18.1.6 (https://github.com/ziglang/zig-bootstrap 98bc6bf4fc4009888d33941daf6b600d20a42a56)";
pub const __GNUC__ = @as(c_int, 4);
pub const __GNUC_MINOR__ = @as(c_int, 2);
pub const __GNUC_PATCHLEVEL__ = @as(c_int, 1);
pub const __GXX_ABI_VERSION = @as(c_int, 1002);
pub const __ATOMIC_RELAXED = @as(c_int, 0);
pub const __ATOMIC_CONSUME = @as(c_int, 1);
pub const __ATOMIC_ACQUIRE = @as(c_int, 2);
pub const __ATOMIC_RELEASE = @as(c_int, 3);
pub const __ATOMIC_ACQ_REL = @as(c_int, 4);
pub const __ATOMIC_SEQ_CST = @as(c_int, 5);
pub const __MEMORY_SCOPE_SYSTEM = @as(c_int, 0);
pub const __MEMORY_SCOPE_DEVICE = @as(c_int, 1);
pub const __MEMORY_SCOPE_WRKGRP = @as(c_int, 2);
pub const __MEMORY_SCOPE_WVFRNT = @as(c_int, 3);
pub const __MEMORY_SCOPE_SINGLE = @as(c_int, 4);
pub const __OPENCL_MEMORY_SCOPE_WORK_ITEM = @as(c_int, 0);
pub const __OPENCL_MEMORY_SCOPE_WORK_GROUP = @as(c_int, 1);
pub const __OPENCL_MEMORY_SCOPE_DEVICE = @as(c_int, 2);
pub const __OPENCL_MEMORY_SCOPE_ALL_SVM_DEVICES = @as(c_int, 3);
pub const __OPENCL_MEMORY_SCOPE_SUB_GROUP = @as(c_int, 4);
pub const __FPCLASS_SNAN = @as(c_int, 0x0001);
pub const __FPCLASS_QNAN = @as(c_int, 0x0002);
pub const __FPCLASS_NEGINF = @as(c_int, 0x0004);
pub const __FPCLASS_NEGNORMAL = @as(c_int, 0x0008);
pub const __FPCLASS_NEGSUBNORMAL = @as(c_int, 0x0010);
pub const __FPCLASS_NEGZERO = @as(c_int, 0x0020);
pub const __FPCLASS_POSZERO = @as(c_int, 0x0040);
pub const __FPCLASS_POSSUBNORMAL = @as(c_int, 0x0080);
pub const __FPCLASS_POSNORMAL = @as(c_int, 0x0100);
pub const __FPCLASS_POSINF = @as(c_int, 0x0200);
pub const __PRAGMA_REDEFINE_EXTNAME = @as(c_int, 1);
pub const __VERSION__ = "Clang 18.1.6 (https://github.com/ziglang/zig-bootstrap 98bc6bf4fc4009888d33941daf6b600d20a42a56)";
pub const __OBJC_BOOL_IS_BOOL = @as(c_int, 0);
pub const __CONSTANT_CFSTRINGS__ = @as(c_int, 1);
pub const __clang_literal_encoding__ = "UTF-8";
pub const __clang_wide_literal_encoding__ = "UTF-32";
pub const __ORDER_LITTLE_ENDIAN__ = @as(c_int, 1234);
pub const __ORDER_BIG_ENDIAN__ = @as(c_int, 4321);
pub const __ORDER_PDP_ENDIAN__ = @as(c_int, 3412);
pub const __BYTE_ORDER__ = __ORDER_LITTLE_ENDIAN__;
pub const __LITTLE_ENDIAN__ = @as(c_int, 1);
pub const _LP64 = @as(c_int, 1);
pub const __LP64__ = @as(c_int, 1);
pub const __CHAR_BIT__ = @as(c_int, 8);
pub const __BOOL_WIDTH__ = @as(c_int, 8);
pub const __SHRT_WIDTH__ = @as(c_int, 16);
pub const __INT_WIDTH__ = @as(c_int, 32);
pub const __LONG_WIDTH__ = @as(c_int, 64);
pub const __LLONG_WIDTH__ = @as(c_int, 64);
pub const __BITINT_MAXWIDTH__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 8388608, .decimal);
pub const __SCHAR_MAX__ = @as(c_int, 127);
pub const __SHRT_MAX__ = @as(c_int, 32767);
pub const __INT_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __LONG_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const __LONG_LONG_MAX__ = @as(c_longlong, 9223372036854775807);
pub const __WCHAR_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __WCHAR_WIDTH__ = @as(c_int, 32);
pub const __WINT_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_uint, 4294967295, .decimal);
pub const __WINT_WIDTH__ = @as(c_int, 32);
pub const __INTMAX_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const __INTMAX_WIDTH__ = @as(c_int, 64);
pub const __SIZE_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const __SIZE_WIDTH__ = @as(c_int, 64);
pub const __UINTMAX_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const __UINTMAX_WIDTH__ = @as(c_int, 64);
pub const __PTRDIFF_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const __PTRDIFF_WIDTH__ = @as(c_int, 64);
pub const __INTPTR_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const __INTPTR_WIDTH__ = @as(c_int, 64);
pub const __UINTPTR_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const __UINTPTR_WIDTH__ = @as(c_int, 64);
pub const __SIZEOF_DOUBLE__ = @as(c_int, 8);
pub const __SIZEOF_FLOAT__ = @as(c_int, 4);
pub const __SIZEOF_INT__ = @as(c_int, 4);
pub const __SIZEOF_LONG__ = @as(c_int, 8);
pub const __SIZEOF_LONG_DOUBLE__ = @as(c_int, 16);
pub const __SIZEOF_LONG_LONG__ = @as(c_int, 8);
pub const __SIZEOF_POINTER__ = @as(c_int, 8);
pub const __SIZEOF_SHORT__ = @as(c_int, 2);
pub const __SIZEOF_PTRDIFF_T__ = @as(c_int, 8);
pub const __SIZEOF_SIZE_T__ = @as(c_int, 8);
pub const __SIZEOF_WCHAR_T__ = @as(c_int, 4);
pub const __SIZEOF_WINT_T__ = @as(c_int, 4);
pub const __SIZEOF_INT128__ = @as(c_int, 16);
pub const __INTMAX_TYPE__ = c_long;
pub const __INTMAX_FMTd__ = "ld";
pub const __INTMAX_FMTi__ = "li";
pub const __INTMAX_C_SUFFIX__ = @compileError("unable to translate macro: undefined identifier `L`");
// (no file):95:9
pub const __UINTMAX_TYPE__ = c_ulong;
pub const __UINTMAX_FMTo__ = "lo";
pub const __UINTMAX_FMTu__ = "lu";
pub const __UINTMAX_FMTx__ = "lx";
pub const __UINTMAX_FMTX__ = "lX";
pub const __UINTMAX_C_SUFFIX__ = @compileError("unable to translate macro: undefined identifier `UL`");
// (no file):101:9
pub const __PTRDIFF_TYPE__ = c_long;
pub const __PTRDIFF_FMTd__ = "ld";
pub const __PTRDIFF_FMTi__ = "li";
pub const __INTPTR_TYPE__ = c_long;
pub const __INTPTR_FMTd__ = "ld";
pub const __INTPTR_FMTi__ = "li";
pub const __SIZE_TYPE__ = c_ulong;
pub const __SIZE_FMTo__ = "lo";
pub const __SIZE_FMTu__ = "lu";
pub const __SIZE_FMTx__ = "lx";
pub const __SIZE_FMTX__ = "lX";
pub const __WCHAR_TYPE__ = c_int;
pub const __WINT_TYPE__ = c_uint;
pub const __SIG_ATOMIC_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __SIG_ATOMIC_WIDTH__ = @as(c_int, 32);
pub const __CHAR16_TYPE__ = c_ushort;
pub const __CHAR32_TYPE__ = c_uint;
pub const __UINTPTR_TYPE__ = c_ulong;
pub const __UINTPTR_FMTo__ = "lo";
pub const __UINTPTR_FMTu__ = "lu";
pub const __UINTPTR_FMTx__ = "lx";
pub const __UINTPTR_FMTX__ = "lX";
pub const __FLT16_DENORM_MIN__ = @as(f16, 5.9604644775390625e-8);
pub const __FLT16_HAS_DENORM__ = @as(c_int, 1);
pub const __FLT16_DIG__ = @as(c_int, 3);
pub const __FLT16_DECIMAL_DIG__ = @as(c_int, 5);
pub const __FLT16_EPSILON__ = @as(f16, 9.765625e-4);
pub const __FLT16_HAS_INFINITY__ = @as(c_int, 1);
pub const __FLT16_HAS_QUIET_NAN__ = @as(c_int, 1);
pub const __FLT16_MANT_DIG__ = @as(c_int, 11);
pub const __FLT16_MAX_10_EXP__ = @as(c_int, 4);
pub const __FLT16_MAX_EXP__ = @as(c_int, 16);
pub const __FLT16_MAX__ = @as(f16, 6.5504e+4);
pub const __FLT16_MIN_10_EXP__ = -@as(c_int, 4);
pub const __FLT16_MIN_EXP__ = -@as(c_int, 13);
pub const __FLT16_MIN__ = @as(f16, 6.103515625e-5);
pub const __FLT_DENORM_MIN__ = @as(f32, 1.40129846e-45);
pub const __FLT_HAS_DENORM__ = @as(c_int, 1);
pub const __FLT_DIG__ = @as(c_int, 6);
pub const __FLT_DECIMAL_DIG__ = @as(c_int, 9);
pub const __FLT_EPSILON__ = @as(f32, 1.19209290e-7);
pub const __FLT_HAS_INFINITY__ = @as(c_int, 1);
pub const __FLT_HAS_QUIET_NAN__ = @as(c_int, 1);
pub const __FLT_MANT_DIG__ = @as(c_int, 24);
pub const __FLT_MAX_10_EXP__ = @as(c_int, 38);
pub const __FLT_MAX_EXP__ = @as(c_int, 128);
pub const __FLT_MAX__ = @as(f32, 3.40282347e+38);
pub const __FLT_MIN_10_EXP__ = -@as(c_int, 37);
pub const __FLT_MIN_EXP__ = -@as(c_int, 125);
pub const __FLT_MIN__ = @as(f32, 1.17549435e-38);
pub const __DBL_DENORM_MIN__ = @as(f64, 4.9406564584124654e-324);
pub const __DBL_HAS_DENORM__ = @as(c_int, 1);
pub const __DBL_DIG__ = @as(c_int, 15);
pub const __DBL_DECIMAL_DIG__ = @as(c_int, 17);
pub const __DBL_EPSILON__ = @as(f64, 2.2204460492503131e-16);
pub const __DBL_HAS_INFINITY__ = @as(c_int, 1);
pub const __DBL_HAS_QUIET_NAN__ = @as(c_int, 1);
pub const __DBL_MANT_DIG__ = @as(c_int, 53);
pub const __DBL_MAX_10_EXP__ = @as(c_int, 308);
pub const __DBL_MAX_EXP__ = @as(c_int, 1024);
pub const __DBL_MAX__ = @as(f64, 1.7976931348623157e+308);
pub const __DBL_MIN_10_EXP__ = -@as(c_int, 307);
pub const __DBL_MIN_EXP__ = -@as(c_int, 1021);
pub const __DBL_MIN__ = @as(f64, 2.2250738585072014e-308);
pub const __LDBL_DENORM_MIN__ = @as(c_longdouble, 3.64519953188247460253e-4951);
pub const __LDBL_HAS_DENORM__ = @as(c_int, 1);
pub const __LDBL_DIG__ = @as(c_int, 18);
pub const __LDBL_DECIMAL_DIG__ = @as(c_int, 21);
pub const __LDBL_EPSILON__ = @as(c_longdouble, 1.08420217248550443401e-19);
pub const __LDBL_HAS_INFINITY__ = @as(c_int, 1);
pub const __LDBL_HAS_QUIET_NAN__ = @as(c_int, 1);
pub const __LDBL_MANT_DIG__ = @as(c_int, 64);
pub const __LDBL_MAX_10_EXP__ = @as(c_int, 4932);
pub const __LDBL_MAX_EXP__ = @as(c_int, 16384);
pub const __LDBL_MAX__ = @as(c_longdouble, 1.18973149535723176502e+4932);
pub const __LDBL_MIN_10_EXP__ = -@as(c_int, 4931);
pub const __LDBL_MIN_EXP__ = -@as(c_int, 16381);
pub const __LDBL_MIN__ = @as(c_longdouble, 3.36210314311209350626e-4932);
pub const __POINTER_WIDTH__ = @as(c_int, 64);
pub const __BIGGEST_ALIGNMENT__ = @as(c_int, 16);
pub const __WINT_UNSIGNED__ = @as(c_int, 1);
pub const __INT8_TYPE__ = i8;
pub const __INT8_FMTd__ = "hhd";
pub const __INT8_FMTi__ = "hhi";
pub const __INT8_C_SUFFIX__ = "";
pub const __INT16_TYPE__ = c_short;
pub const __INT16_FMTd__ = "hd";
pub const __INT16_FMTi__ = "hi";
pub const __INT16_C_SUFFIX__ = "";
pub const __INT32_TYPE__ = c_int;
pub const __INT32_FMTd__ = "d";
pub const __INT32_FMTi__ = "i";
pub const __INT32_C_SUFFIX__ = "";
pub const __INT64_TYPE__ = c_long;
pub const __INT64_FMTd__ = "ld";
pub const __INT64_FMTi__ = "li";
pub const __INT64_C_SUFFIX__ = @compileError("unable to translate macro: undefined identifier `L`");
// (no file):198:9
pub const __UINT8_TYPE__ = u8;
pub const __UINT8_FMTo__ = "hho";
pub const __UINT8_FMTu__ = "hhu";
pub const __UINT8_FMTx__ = "hhx";
pub const __UINT8_FMTX__ = "hhX";
pub const __UINT8_C_SUFFIX__ = "";
pub const __UINT8_MAX__ = @as(c_int, 255);
pub const __INT8_MAX__ = @as(c_int, 127);
pub const __UINT16_TYPE__ = c_ushort;
pub const __UINT16_FMTo__ = "ho";
pub const __UINT16_FMTu__ = "hu";
pub const __UINT16_FMTx__ = "hx";
pub const __UINT16_FMTX__ = "hX";
pub const __UINT16_C_SUFFIX__ = "";
pub const __UINT16_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 65535, .decimal);
pub const __INT16_MAX__ = @as(c_int, 32767);
pub const __UINT32_TYPE__ = c_uint;
pub const __UINT32_FMTo__ = "o";
pub const __UINT32_FMTu__ = "u";
pub const __UINT32_FMTx__ = "x";
pub const __UINT32_FMTX__ = "X";
pub const __UINT32_C_SUFFIX__ = @compileError("unable to translate macro: undefined identifier `U`");
// (no file):220:9
pub const __UINT32_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_uint, 4294967295, .decimal);
pub const __INT32_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __UINT64_TYPE__ = c_ulong;
pub const __UINT64_FMTo__ = "lo";
pub const __UINT64_FMTu__ = "lu";
pub const __UINT64_FMTx__ = "lx";
pub const __UINT64_FMTX__ = "lX";
pub const __UINT64_C_SUFFIX__ = @compileError("unable to translate macro: undefined identifier `UL`");
// (no file):228:9
pub const __UINT64_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const __INT64_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const __INT_LEAST8_TYPE__ = i8;
pub const __INT_LEAST8_MAX__ = @as(c_int, 127);
pub const __INT_LEAST8_WIDTH__ = @as(c_int, 8);
pub const __INT_LEAST8_FMTd__ = "hhd";
pub const __INT_LEAST8_FMTi__ = "hhi";
pub const __UINT_LEAST8_TYPE__ = u8;
pub const __UINT_LEAST8_MAX__ = @as(c_int, 255);
pub const __UINT_LEAST8_FMTo__ = "hho";
pub const __UINT_LEAST8_FMTu__ = "hhu";
pub const __UINT_LEAST8_FMTx__ = "hhx";
pub const __UINT_LEAST8_FMTX__ = "hhX";
pub const __INT_LEAST16_TYPE__ = c_short;
pub const __INT_LEAST16_MAX__ = @as(c_int, 32767);
pub const __INT_LEAST16_WIDTH__ = @as(c_int, 16);
pub const __INT_LEAST16_FMTd__ = "hd";
pub const __INT_LEAST16_FMTi__ = "hi";
pub const __UINT_LEAST16_TYPE__ = c_ushort;
pub const __UINT_LEAST16_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 65535, .decimal);
pub const __UINT_LEAST16_FMTo__ = "ho";
pub const __UINT_LEAST16_FMTu__ = "hu";
pub const __UINT_LEAST16_FMTx__ = "hx";
pub const __UINT_LEAST16_FMTX__ = "hX";
pub const __INT_LEAST32_TYPE__ = c_int;
pub const __INT_LEAST32_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __INT_LEAST32_WIDTH__ = @as(c_int, 32);
pub const __INT_LEAST32_FMTd__ = "d";
pub const __INT_LEAST32_FMTi__ = "i";
pub const __UINT_LEAST32_TYPE__ = c_uint;
pub const __UINT_LEAST32_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_uint, 4294967295, .decimal);
pub const __UINT_LEAST32_FMTo__ = "o";
pub const __UINT_LEAST32_FMTu__ = "u";
pub const __UINT_LEAST32_FMTx__ = "x";
pub const __UINT_LEAST32_FMTX__ = "X";
pub const __INT_LEAST64_TYPE__ = c_long;
pub const __INT_LEAST64_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const __INT_LEAST64_WIDTH__ = @as(c_int, 64);
pub const __INT_LEAST64_FMTd__ = "ld";
pub const __INT_LEAST64_FMTi__ = "li";
pub const __UINT_LEAST64_TYPE__ = c_ulong;
pub const __UINT_LEAST64_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const __UINT_LEAST64_FMTo__ = "lo";
pub const __UINT_LEAST64_FMTu__ = "lu";
pub const __UINT_LEAST64_FMTx__ = "lx";
pub const __UINT_LEAST64_FMTX__ = "lX";
pub const __INT_FAST8_TYPE__ = i8;
pub const __INT_FAST8_MAX__ = @as(c_int, 127);
pub const __INT_FAST8_WIDTH__ = @as(c_int, 8);
pub const __INT_FAST8_FMTd__ = "hhd";
pub const __INT_FAST8_FMTi__ = "hhi";
pub const __UINT_FAST8_TYPE__ = u8;
pub const __UINT_FAST8_MAX__ = @as(c_int, 255);
pub const __UINT_FAST8_FMTo__ = "hho";
pub const __UINT_FAST8_FMTu__ = "hhu";
pub const __UINT_FAST8_FMTx__ = "hhx";
pub const __UINT_FAST8_FMTX__ = "hhX";
pub const __INT_FAST16_TYPE__ = c_short;
pub const __INT_FAST16_MAX__ = @as(c_int, 32767);
pub const __INT_FAST16_WIDTH__ = @as(c_int, 16);
pub const __INT_FAST16_FMTd__ = "hd";
pub const __INT_FAST16_FMTi__ = "hi";
pub const __UINT_FAST16_TYPE__ = c_ushort;
pub const __UINT_FAST16_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 65535, .decimal);
pub const __UINT_FAST16_FMTo__ = "ho";
pub const __UINT_FAST16_FMTu__ = "hu";
pub const __UINT_FAST16_FMTx__ = "hx";
pub const __UINT_FAST16_FMTX__ = "hX";
pub const __INT_FAST32_TYPE__ = c_int;
pub const __INT_FAST32_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __INT_FAST32_WIDTH__ = @as(c_int, 32);
pub const __INT_FAST32_FMTd__ = "d";
pub const __INT_FAST32_FMTi__ = "i";
pub const __UINT_FAST32_TYPE__ = c_uint;
pub const __UINT_FAST32_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_uint, 4294967295, .decimal);
pub const __UINT_FAST32_FMTo__ = "o";
pub const __UINT_FAST32_FMTu__ = "u";
pub const __UINT_FAST32_FMTx__ = "x";
pub const __UINT_FAST32_FMTX__ = "X";
pub const __INT_FAST64_TYPE__ = c_long;
pub const __INT_FAST64_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const __INT_FAST64_WIDTH__ = @as(c_int, 64);
pub const __INT_FAST64_FMTd__ = "ld";
pub const __INT_FAST64_FMTi__ = "li";
pub const __UINT_FAST64_TYPE__ = c_ulong;
pub const __UINT_FAST64_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const __UINT_FAST64_FMTo__ = "lo";
pub const __UINT_FAST64_FMTu__ = "lu";
pub const __UINT_FAST64_FMTx__ = "lx";
pub const __UINT_FAST64_FMTX__ = "lX";
pub const __USER_LABEL_PREFIX__ = "";
pub const __FINITE_MATH_ONLY__ = @as(c_int, 0);
pub const __GNUC_STDC_INLINE__ = @as(c_int, 1);
pub const __GCC_ATOMIC_TEST_AND_SET_TRUEVAL = @as(c_int, 1);
pub const __CLANG_ATOMIC_BOOL_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_CHAR_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_CHAR16_T_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_CHAR32_T_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_WCHAR_T_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_SHORT_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_INT_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_LONG_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_LLONG_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_POINTER_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_BOOL_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_CHAR_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_CHAR16_T_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_CHAR32_T_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_WCHAR_T_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_SHORT_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_INT_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_LONG_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_LLONG_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_POINTER_LOCK_FREE = @as(c_int, 2);
pub const __NO_INLINE__ = @as(c_int, 1);
pub const __PIC__ = @as(c_int, 2);
pub const __pic__ = @as(c_int, 2);
pub const __PIE__ = @as(c_int, 2);
pub const __pie__ = @as(c_int, 2);
pub const __FLT_RADIX__ = @as(c_int, 2);
pub const __DECIMAL_DIG__ = __LDBL_DECIMAL_DIG__;
pub const __ELF__ = @as(c_int, 1);
pub const __GCC_ASM_FLAG_OUTPUTS__ = @as(c_int, 1);
pub const __code_model_small__ = @as(c_int, 1);
pub const __amd64__ = @as(c_int, 1);
pub const __amd64 = @as(c_int, 1);
pub const __x86_64 = @as(c_int, 1);
pub const __x86_64__ = @as(c_int, 1);
pub const __SEG_GS = @as(c_int, 1);
pub const __SEG_FS = @as(c_int, 1);
pub const __seg_gs = @compileError("unable to translate macro: undefined identifier `address_space`");
// (no file):359:9
pub const __seg_fs = @compileError("unable to translate macro: undefined identifier `address_space`");
// (no file):360:9
pub const __znver1 = @as(c_int, 1);
pub const __znver1__ = @as(c_int, 1);
pub const __tune_znver1__ = @as(c_int, 1);
pub const __REGISTER_PREFIX__ = "";
pub const __NO_MATH_INLINES = @as(c_int, 1);
pub const __AES__ = @as(c_int, 1);
pub const __PCLMUL__ = @as(c_int, 1);
pub const __LAHF_SAHF__ = @as(c_int, 1);
pub const __LZCNT__ = @as(c_int, 1);
pub const __RDRND__ = @as(c_int, 1);
pub const __FSGSBASE__ = @as(c_int, 1);
pub const __BMI__ = @as(c_int, 1);
pub const __BMI2__ = @as(c_int, 1);
pub const __POPCNT__ = @as(c_int, 1);
pub const __PRFCHW__ = @as(c_int, 1);
pub const __RDSEED__ = @as(c_int, 1);
pub const __ADX__ = @as(c_int, 1);
pub const __MWAITX__ = @as(c_int, 1);
pub const __MOVBE__ = @as(c_int, 1);
pub const __SSE4A__ = @as(c_int, 1);
pub const __FMA__ = @as(c_int, 1);
pub const __F16C__ = @as(c_int, 1);
pub const __SHA__ = @as(c_int, 1);
pub const __FXSR__ = @as(c_int, 1);
pub const __XSAVE__ = @as(c_int, 1);
pub const __XSAVEOPT__ = @as(c_int, 1);
pub const __XSAVEC__ = @as(c_int, 1);
pub const __XSAVES__ = @as(c_int, 1);
pub const __CLFLUSHOPT__ = @as(c_int, 1);
pub const __CLZERO__ = @as(c_int, 1);
pub const __CRC32__ = @as(c_int, 1);
pub const __AVX2__ = @as(c_int, 1);
pub const __AVX__ = @as(c_int, 1);
pub const __SSE4_2__ = @as(c_int, 1);
pub const __SSE4_1__ = @as(c_int, 1);
pub const __SSSE3__ = @as(c_int, 1);
pub const __SSE3__ = @as(c_int, 1);
pub const __SSE2__ = @as(c_int, 1);
pub const __SSE2_MATH__ = @as(c_int, 1);
pub const __SSE__ = @as(c_int, 1);
pub const __SSE_MATH__ = @as(c_int, 1);
pub const __MMX__ = @as(c_int, 1);
pub const __GCC_HAVE_SYNC_COMPARE_AND_SWAP_1 = @as(c_int, 1);
pub const __GCC_HAVE_SYNC_COMPARE_AND_SWAP_2 = @as(c_int, 1);
pub const __GCC_HAVE_SYNC_COMPARE_AND_SWAP_4 = @as(c_int, 1);
pub const __GCC_HAVE_SYNC_COMPARE_AND_SWAP_8 = @as(c_int, 1);
pub const __GCC_HAVE_SYNC_COMPARE_AND_SWAP_16 = @as(c_int, 1);
pub const __SIZEOF_FLOAT128__ = @as(c_int, 16);
pub const unix = @as(c_int, 1);
pub const __unix = @as(c_int, 1);
pub const __unix__ = @as(c_int, 1);
pub const linux = @as(c_int, 1);
pub const __linux = @as(c_int, 1);
pub const __linux__ = @as(c_int, 1);
pub const __gnu_linux__ = @as(c_int, 1);
pub const __FLOAT128__ = @as(c_int, 1);
pub const __STDC__ = @as(c_int, 1);
pub const __STDC_HOSTED__ = @as(c_int, 1);
pub const __STDC_VERSION__ = @as(c_long, 201710);
pub const __STDC_UTF_16__ = @as(c_int, 1);
pub const __STDC_UTF_32__ = @as(c_int, 1);
pub const _DEBUG = @as(c_int, 1);
pub const __GCC_HAVE_DWARF2_CFI_ASM = @as(c_int, 1);
pub const LLVM_CLANG_C_INDEX_H = "";
pub const LLVM_CLANG_C_BUILDSYSTEM_H = "";
pub const LLVM_CLANG_C_CXERRORCODE_H = "";
pub const LLVM_CLANG_C_EXTERN_C_H = "";
pub const LLVM_CLANG_C_STRICT_PROTOTYPES_BEGIN = @compileError("unable to translate macro: undefined identifier `_Pragma`");
// /usr/include/clang-c/ExternC.h:18:9
pub const LLVM_CLANG_C_STRICT_PROTOTYPES_END = @compileError("unable to translate macro: undefined identifier `_Pragma`");
// /usr/include/clang-c/ExternC.h:21:9
pub const LLVM_CLANG_C_EXTERN_C_BEGIN = LLVM_CLANG_C_STRICT_PROTOTYPES_BEGIN;
pub const LLVM_CLANG_C_EXTERN_C_END = LLVM_CLANG_C_STRICT_PROTOTYPES_END;
pub const LLVM_CLANG_C_PLATFORM_H = "";
pub const CINDEX_EXPORTS = "";
pub const CINDEX_LINKAGE = @compileError("unable to translate macro: undefined identifier `visibility`");
// /usr/include/clang-c/Platform.h:34:11
pub const CINDEX_DEPRECATED = @compileError("unable to translate macro: undefined identifier `deprecated`");
// /usr/include/clang-c/Platform.h:42:11
pub const LLVM_CLANG_C_CXSTRING_H = "";
pub const LLVM_CLANG_C_CXDIAGNOSTIC_H = "";
pub const LLVM_CLANG_C_CXSOURCE_LOCATION_H = "";
pub const LLVM_CLANG_C_CXFILE_H = "";
pub const _TIME_H = @as(c_int, 1);
pub const _FEATURES_H = @as(c_int, 1);
pub const __KERNEL_STRICT_NAMES = "";
pub inline fn __GNUC_PREREQ(maj: anytype, min: anytype) @TypeOf(((__GNUC__ << @as(c_int, 16)) + __GNUC_MINOR__) >= ((maj << @as(c_int, 16)) + min)) {
    _ = &maj;
    _ = &min;
    return ((__GNUC__ << @as(c_int, 16)) + __GNUC_MINOR__) >= ((maj << @as(c_int, 16)) + min);
}
pub inline fn __glibc_clang_prereq(maj: anytype, min: anytype) @TypeOf(((__clang_major__ << @as(c_int, 16)) + __clang_minor__) >= ((maj << @as(c_int, 16)) + min)) {
    _ = &maj;
    _ = &min;
    return ((__clang_major__ << @as(c_int, 16)) + __clang_minor__) >= ((maj << @as(c_int, 16)) + min);
}
pub const __GLIBC_USE = @compileError("unable to translate macro: undefined identifier `__GLIBC_USE_`");
// /usr/include/features.h:189:9
pub const _DEFAULT_SOURCE = @as(c_int, 1);
pub const __GLIBC_USE_ISOC23 = @as(c_int, 0);
pub const __USE_ISOC11 = @as(c_int, 1);
pub const __USE_ISOC99 = @as(c_int, 1);
pub const __USE_ISOC95 = @as(c_int, 1);
pub const __USE_POSIX_IMPLICITLY = @as(c_int, 1);
pub const _POSIX_SOURCE = @as(c_int, 1);
pub const _POSIX_C_SOURCE = @as(c_long, 200809);
pub const __USE_POSIX = @as(c_int, 1);
pub const __USE_POSIX2 = @as(c_int, 1);
pub const __USE_POSIX199309 = @as(c_int, 1);
pub const __USE_POSIX199506 = @as(c_int, 1);
pub const __USE_XOPEN2K = @as(c_int, 1);
pub const __USE_XOPEN2K8 = @as(c_int, 1);
pub const _ATFILE_SOURCE = @as(c_int, 1);
pub const __WORDSIZE = @as(c_int, 64);
pub const __WORDSIZE_TIME64_COMPAT32 = @as(c_int, 1);
pub const __SYSCALL_WORDSIZE = @as(c_int, 64);
pub const __TIMESIZE = __WORDSIZE;
pub const __USE_TIME_BITS64 = @as(c_int, 1);
pub const __USE_MISC = @as(c_int, 1);
pub const __USE_ATFILE = @as(c_int, 1);
pub const __USE_FORTIFY_LEVEL = @as(c_int, 0);
pub const __GLIBC_USE_DEPRECATED_GETS = @as(c_int, 0);
pub const __GLIBC_USE_DEPRECATED_SCANF = @as(c_int, 0);
pub const __GLIBC_USE_C23_STRTOL = @as(c_int, 0);
pub const _STDC_PREDEF_H = @as(c_int, 1);
pub const __STDC_IEC_559__ = @as(c_int, 1);
pub const __STDC_IEC_60559_BFP__ = @as(c_long, 201404);
pub const __STDC_IEC_559_COMPLEX__ = @as(c_int, 1);
pub const __STDC_IEC_60559_COMPLEX__ = @as(c_long, 201404);
pub const __STDC_ISO_10646__ = @as(c_long, 201706);
pub const __GNU_LIBRARY__ = @as(c_int, 6);
pub const __GLIBC__ = @as(c_int, 2);
pub const __GLIBC_MINOR__ = @as(c_int, 40);
pub inline fn __GLIBC_PREREQ(maj: anytype, min: anytype) @TypeOf(((__GLIBC__ << @as(c_int, 16)) + __GLIBC_MINOR__) >= ((maj << @as(c_int, 16)) + min)) {
    _ = &maj;
    _ = &min;
    return ((__GLIBC__ << @as(c_int, 16)) + __GLIBC_MINOR__) >= ((maj << @as(c_int, 16)) + min);
}
pub const _SYS_CDEFS_H = @as(c_int, 1);
pub const __glibc_has_attribute = @compileError("unable to translate macro: undefined identifier `__has_attribute`");
// /usr/include/sys/cdefs.h:45:10
pub inline fn __glibc_has_builtin(name: anytype) @TypeOf(__has_builtin(name)) {
    _ = &name;
    return __has_builtin(name);
}
pub const __glibc_has_extension = @compileError("unable to translate macro: undefined identifier `__has_extension`");
// /usr/include/sys/cdefs.h:55:10
pub const __LEAF = "";
pub const __LEAF_ATTR = "";
pub const __THROW = @compileError("unable to translate macro: undefined identifier `__nothrow__`");
// /usr/include/sys/cdefs.h:79:11
pub const __THROWNL = @compileError("unable to translate macro: undefined identifier `__nothrow__`");
// /usr/include/sys/cdefs.h:80:11
pub const __NTH = @compileError("unable to translate macro: undefined identifier `__nothrow__`");
// /usr/include/sys/cdefs.h:81:11
pub const __NTHNL = @compileError("unable to translate macro: undefined identifier `__nothrow__`");
// /usr/include/sys/cdefs.h:82:11
pub const __COLD = @compileError("unable to translate macro: undefined identifier `__cold__`");
// /usr/include/sys/cdefs.h:102:11
pub inline fn __P(args: anytype) @TypeOf(args) {
    _ = &args;
    return args;
}
pub inline fn __PMT(args: anytype) @TypeOf(args) {
    _ = &args;
    return args;
}
pub const __CONCAT = @compileError("unable to translate C expr: unexpected token '##'");
// /usr/include/sys/cdefs.h:131:9
pub const __STRING = @compileError("unable to translate C expr: unexpected token '#'");
// /usr/include/sys/cdefs.h:132:9
pub const __ptr_t = ?*anyopaque;
pub const __BEGIN_DECLS = "";
pub const __END_DECLS = "";
pub const __attribute_overloadable__ = @compileError("unable to translate macro: undefined identifier `__overloadable__`");
// /usr/include/sys/cdefs.h:151:10
pub inline fn __bos(ptr: anytype) @TypeOf(__builtin_object_size(ptr, __USE_FORTIFY_LEVEL > @as(c_int, 1))) {
    _ = &ptr;
    return __builtin_object_size(ptr, __USE_FORTIFY_LEVEL > @as(c_int, 1));
}
pub inline fn __bos0(ptr: anytype) @TypeOf(__builtin_object_size(ptr, @as(c_int, 0))) {
    _ = &ptr;
    return __builtin_object_size(ptr, @as(c_int, 0));
}
pub inline fn __glibc_objsize0(__o: anytype) @TypeOf(__bos0(__o)) {
    _ = &__o;
    return __bos0(__o);
}
pub inline fn __glibc_objsize(__o: anytype) @TypeOf(__bos(__o)) {
    _ = &__o;
    return __bos(__o);
}
pub const __warnattr = @compileError("unable to translate C expr: unexpected token ''");
// /usr/include/sys/cdefs.h:370:10
pub const __errordecl = @compileError("unable to translate C expr: unexpected token 'extern'");
// /usr/include/sys/cdefs.h:371:10
pub const __flexarr = @compileError("unable to translate C expr: unexpected token '['");
// /usr/include/sys/cdefs.h:379:10
pub const __glibc_c99_flexarr_available = @as(c_int, 1);
pub const __REDIRECT = @compileError("unable to translate C expr: unexpected token '__asm__'");
// /usr/include/sys/cdefs.h:410:10
pub const __REDIRECT_NTH = @compileError("unable to translate C expr: unexpected token '__asm__'");
// /usr/include/sys/cdefs.h:417:11
pub const __REDIRECT_NTHNL = @compileError("unable to translate C expr: unexpected token '__asm__'");
// /usr/include/sys/cdefs.h:419:11
pub const __ASMNAME = @compileError("unable to translate C expr: unexpected token ','");
// /usr/include/sys/cdefs.h:422:10
pub inline fn __ASMNAME2(prefix: anytype, cname: anytype) @TypeOf(__STRING(prefix) ++ cname) {
    _ = &prefix;
    _ = &cname;
    return __STRING(prefix) ++ cname;
}
pub const __REDIRECT_FORTIFY = __REDIRECT;
pub const __REDIRECT_FORTIFY_NTH = __REDIRECT_NTH;
pub const __attribute_malloc__ = @compileError("unable to translate macro: undefined identifier `__malloc__`");
// /usr/include/sys/cdefs.h:452:10
pub const __attribute_alloc_size__ = @compileError("unable to translate C expr: unexpected token ''");
// /usr/include/sys/cdefs.h:463:10
pub const __attribute_alloc_align__ = @compileError("unable to translate macro: undefined identifier `__alloc_align__`");
// /usr/include/sys/cdefs.h:469:10
pub const __attribute_pure__ = @compileError("unable to translate macro: undefined identifier `__pure__`");
// /usr/include/sys/cdefs.h:479:10
pub const __attribute_const__ = @compileError("unable to translate C expr: unexpected token '__attribute__'");
// /usr/include/sys/cdefs.h:486:10
pub const __attribute_maybe_unused__ = @compileError("unable to translate macro: undefined identifier `__unused__`");
// /usr/include/sys/cdefs.h:492:10
pub const __attribute_used__ = @compileError("unable to translate macro: undefined identifier `__used__`");
// /usr/include/sys/cdefs.h:501:10
pub const __attribute_noinline__ = @compileError("unable to translate macro: undefined identifier `__noinline__`");
// /usr/include/sys/cdefs.h:502:10
pub const __attribute_deprecated__ = @compileError("unable to translate macro: undefined identifier `__deprecated__`");
// /usr/include/sys/cdefs.h:510:10
pub const __attribute_deprecated_msg__ = @compileError("unable to translate macro: undefined identifier `__deprecated__`");
// /usr/include/sys/cdefs.h:520:10
pub const __attribute_format_arg__ = @compileError("unable to translate macro: undefined identifier `__format_arg__`");
// /usr/include/sys/cdefs.h:533:10
pub const __attribute_format_strfmon__ = @compileError("unable to translate macro: undefined identifier `__format__`");
// /usr/include/sys/cdefs.h:543:10
pub const __attribute_nonnull__ = @compileError("unable to translate macro: undefined identifier `__nonnull__`");
// /usr/include/sys/cdefs.h:555:11
pub inline fn __nonnull(params: anytype) @TypeOf(__attribute_nonnull__(params)) {
    _ = &params;
    return __attribute_nonnull__(params);
}
pub const __returns_nonnull = @compileError("unable to translate macro: undefined identifier `__returns_nonnull__`");
// /usr/include/sys/cdefs.h:568:10
pub const __attribute_warn_unused_result__ = @compileError("unable to translate macro: undefined identifier `__warn_unused_result__`");
// /usr/include/sys/cdefs.h:577:10
pub const __wur = "";
pub const __always_inline = @compileError("unable to translate macro: undefined identifier `__always_inline__`");
// /usr/include/sys/cdefs.h:595:10
pub const __attribute_artificial__ = @compileError("unable to translate macro: undefined identifier `__artificial__`");
// /usr/include/sys/cdefs.h:604:10
pub const __extern_inline = @compileError("unable to translate macro: undefined identifier `__gnu_inline__`");
// /usr/include/sys/cdefs.h:622:11
pub const __extern_always_inline = @compileError("unable to translate macro: undefined identifier `__gnu_inline__`");
// /usr/include/sys/cdefs.h:623:11
pub const __fortify_function = __extern_always_inline ++ __attribute_artificial__;
pub const __restrict_arr = @compileError("unable to translate C expr: unexpected token '__restrict'");
// /usr/include/sys/cdefs.h:666:10
pub inline fn __glibc_unlikely(cond: anytype) @TypeOf(__builtin_expect(cond, @as(c_int, 0))) {
    _ = &cond;
    return __builtin_expect(cond, @as(c_int, 0));
}
pub inline fn __glibc_likely(cond: anytype) @TypeOf(__builtin_expect(cond, @as(c_int, 1))) {
    _ = &cond;
    return __builtin_expect(cond, @as(c_int, 1));
}
pub const __attribute_nonstring__ = "";
pub const __attribute_copy__ = @compileError("unable to translate C expr: unexpected token ''");
// /usr/include/sys/cdefs.h:715:10
pub const __LDOUBLE_REDIRECTS_TO_FLOAT128_ABI = @as(c_int, 0);
pub inline fn __LDBL_REDIR1(name: anytype, proto: anytype, alias: anytype) @TypeOf(name ++ proto) {
    _ = &name;
    _ = &proto;
    _ = &alias;
    return name ++ proto;
}
pub inline fn __LDBL_REDIR(name: anytype, proto: anytype) @TypeOf(name ++ proto) {
    _ = &name;
    _ = &proto;
    return name ++ proto;
}
pub inline fn __LDBL_REDIR1_NTH(name: anytype, proto: anytype, alias: anytype) @TypeOf(name ++ proto ++ __THROW) {
    _ = &name;
    _ = &proto;
    _ = &alias;
    return name ++ proto ++ __THROW;
}
pub inline fn __LDBL_REDIR_NTH(name: anytype, proto: anytype) @TypeOf(name ++ proto ++ __THROW) {
    _ = &name;
    _ = &proto;
    return name ++ proto ++ __THROW;
}
pub const __LDBL_REDIR2_DECL = @compileError("unable to translate C expr: unexpected token ''");
// /usr/include/sys/cdefs.h:792:10
pub const __LDBL_REDIR_DECL = @compileError("unable to translate C expr: unexpected token ''");
// /usr/include/sys/cdefs.h:793:10
pub inline fn __REDIRECT_LDBL(name: anytype, proto: anytype, alias: anytype) @TypeOf(__REDIRECT(name, proto, alias)) {
    _ = &name;
    _ = &proto;
    _ = &alias;
    return __REDIRECT(name, proto, alias);
}
pub inline fn __REDIRECT_NTH_LDBL(name: anytype, proto: anytype, alias: anytype) @TypeOf(__REDIRECT_NTH(name, proto, alias)) {
    _ = &name;
    _ = &proto;
    _ = &alias;
    return __REDIRECT_NTH(name, proto, alias);
}
pub const __glibc_macro_warning1 = @compileError("unable to translate macro: undefined identifier `_Pragma`");
// /usr/include/sys/cdefs.h:807:10
pub const __glibc_macro_warning = @compileError("unable to translate macro: undefined identifier `GCC`");
// /usr/include/sys/cdefs.h:808:10
pub const __HAVE_GENERIC_SELECTION = @as(c_int, 1);
pub const __fortified_attr_access = @compileError("unable to translate C expr: unexpected token ''");
// /usr/include/sys/cdefs.h:853:11
pub const __attr_access = @compileError("unable to translate C expr: unexpected token ''");
// /usr/include/sys/cdefs.h:854:11
pub const __attr_access_none = @compileError("unable to translate C expr: unexpected token ''");
// /usr/include/sys/cdefs.h:855:11
pub const __attr_dealloc = @compileError("unable to translate C expr: unexpected token ''");
// /usr/include/sys/cdefs.h:865:10
pub const __attr_dealloc_free = "";
pub const __attribute_returns_twice__ = @compileError("unable to translate macro: undefined identifier `__returns_twice__`");
// /usr/include/sys/cdefs.h:872:10
pub const __attribute_struct_may_alias__ = @compileError("unable to translate macro: undefined identifier `__may_alias__`");
// /usr/include/sys/cdefs.h:881:10
pub const __stub___compat_bdflush = "";
pub const __stub_chflags = "";
pub const __stub_fchflags = "";
pub const __stub_gtty = "";
pub const __stub_revoke = "";
pub const __stub_setlogin = "";
pub const __stub_sigreturn = "";
pub const __stub_stty = "";
pub const __need_size_t = "";
pub const __need_NULL = "";
pub const _SIZE_T = "";
pub const NULL = @import("std").zig.c_translation.cast(?*anyopaque, @as(c_int, 0));
pub const _BITS_TIME_H = @as(c_int, 1);
pub const _BITS_TYPES_H = @as(c_int, 1);
pub const __S16_TYPE = c_short;
pub const __U16_TYPE = c_ushort;
pub const __S32_TYPE = c_int;
pub const __U32_TYPE = c_uint;
pub const __SLONGWORD_TYPE = c_long;
pub const __ULONGWORD_TYPE = c_ulong;
pub const __SQUAD_TYPE = c_long;
pub const __UQUAD_TYPE = c_ulong;
pub const __SWORD_TYPE = c_long;
pub const __UWORD_TYPE = c_ulong;
pub const __SLONG32_TYPE = c_int;
pub const __ULONG32_TYPE = c_uint;
pub const __S64_TYPE = c_long;
pub const __U64_TYPE = c_ulong;
pub const __STD_TYPE = @compileError("unable to translate C expr: unexpected token 'typedef'");
// /usr/include/bits/types.h:137:10
pub const _BITS_TYPESIZES_H = @as(c_int, 1);
pub const __SYSCALL_SLONG_TYPE = __SLONGWORD_TYPE;
pub const __SYSCALL_ULONG_TYPE = __ULONGWORD_TYPE;
pub const __DEV_T_TYPE = __UQUAD_TYPE;
pub const __UID_T_TYPE = __U32_TYPE;
pub const __GID_T_TYPE = __U32_TYPE;
pub const __INO_T_TYPE = __SYSCALL_ULONG_TYPE;
pub const __INO64_T_TYPE = __UQUAD_TYPE;
pub const __MODE_T_TYPE = __U32_TYPE;
pub const __NLINK_T_TYPE = __SYSCALL_ULONG_TYPE;
pub const __FSWORD_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __OFF_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __OFF64_T_TYPE = __SQUAD_TYPE;
pub const __PID_T_TYPE = __S32_TYPE;
pub const __RLIM_T_TYPE = __SYSCALL_ULONG_TYPE;
pub const __RLIM64_T_TYPE = __UQUAD_TYPE;
pub const __BLKCNT_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __BLKCNT64_T_TYPE = __SQUAD_TYPE;
pub const __FSBLKCNT_T_TYPE = __SYSCALL_ULONG_TYPE;
pub const __FSBLKCNT64_T_TYPE = __UQUAD_TYPE;
pub const __FSFILCNT_T_TYPE = __SYSCALL_ULONG_TYPE;
pub const __FSFILCNT64_T_TYPE = __UQUAD_TYPE;
pub const __ID_T_TYPE = __U32_TYPE;
pub const __CLOCK_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __TIME_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __USECONDS_T_TYPE = __U32_TYPE;
pub const __SUSECONDS_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __SUSECONDS64_T_TYPE = __SQUAD_TYPE;
pub const __DADDR_T_TYPE = __S32_TYPE;
pub const __KEY_T_TYPE = __S32_TYPE;
pub const __CLOCKID_T_TYPE = __S32_TYPE;
pub const __TIMER_T_TYPE = ?*anyopaque;
pub const __BLKSIZE_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __FSID_T_TYPE = @compileError("unable to translate macro: undefined identifier `__val`");
// /usr/include/bits/typesizes.h:73:9
pub const __SSIZE_T_TYPE = __SWORD_TYPE;
pub const __CPU_MASK_TYPE = __SYSCALL_ULONG_TYPE;
pub const __OFF_T_MATCHES_OFF64_T = @as(c_int, 1);
pub const __INO_T_MATCHES_INO64_T = @as(c_int, 1);
pub const __RLIM_T_MATCHES_RLIM64_T = @as(c_int, 1);
pub const __STATFS_MATCHES_STATFS64 = @as(c_int, 1);
pub const __KERNEL_OLD_TIMEVAL_MATCHES_TIMEVAL64 = @as(c_int, 1);
pub const __FD_SETSIZE = @as(c_int, 1024);
pub const _BITS_TIME64_H = @as(c_int, 1);
pub const __TIME64_T_TYPE = __TIME_T_TYPE;
pub const CLOCKS_PER_SEC = @import("std").zig.c_translation.cast(__clock_t, @import("std").zig.c_translation.promoteIntLiteral(c_int, 1000000, .decimal));
pub const CLOCK_REALTIME = @as(c_int, 0);
pub const CLOCK_MONOTONIC = @as(c_int, 1);
pub const CLOCK_PROCESS_CPUTIME_ID = @as(c_int, 2);
pub const CLOCK_THREAD_CPUTIME_ID = @as(c_int, 3);
pub const CLOCK_MONOTONIC_RAW = @as(c_int, 4);
pub const CLOCK_REALTIME_COARSE = @as(c_int, 5);
pub const CLOCK_MONOTONIC_COARSE = @as(c_int, 6);
pub const CLOCK_BOOTTIME = @as(c_int, 7);
pub const CLOCK_REALTIME_ALARM = @as(c_int, 8);
pub const CLOCK_BOOTTIME_ALARM = @as(c_int, 9);
pub const CLOCK_TAI = @as(c_int, 11);
pub const TIMER_ABSTIME = @as(c_int, 1);
pub const __clock_t_defined = @as(c_int, 1);
pub const __time_t_defined = @as(c_int, 1);
pub const __struct_tm_defined = @as(c_int, 1);
pub const _STRUCT_TIMESPEC = @as(c_int, 1);
pub const _BITS_ENDIAN_H = @as(c_int, 1);
pub const __LITTLE_ENDIAN = @as(c_int, 1234);
pub const __BIG_ENDIAN = @as(c_int, 4321);
pub const __PDP_ENDIAN = @as(c_int, 3412);
pub const _BITS_ENDIANNESS_H = @as(c_int, 1);
pub const __BYTE_ORDER = __LITTLE_ENDIAN;
pub const __FLOAT_WORD_ORDER = __BYTE_ORDER;
pub inline fn __LONG_LONG_PAIR(HI: anytype, LO: anytype) @TypeOf(HI) {
    _ = &HI;
    _ = &LO;
    return blk: {
        _ = &LO;
        break :blk HI;
    };
}
pub const __clockid_t_defined = @as(c_int, 1);
pub const __timer_t_defined = @as(c_int, 1);
pub const __itimerspec_defined = @as(c_int, 1);
pub const __pid_t_defined = "";
pub const _BITS_TYPES_LOCALE_T_H = @as(c_int, 1);
pub const _BITS_TYPES___LOCALE_T_H = @as(c_int, 1);
pub const TIME_UTC = @as(c_int, 1);
pub inline fn __isleap(year: anytype) @TypeOf((@import("std").zig.c_translation.MacroArithmetic.rem(year, @as(c_int, 4)) == @as(c_int, 0)) and ((@import("std").zig.c_translation.MacroArithmetic.rem(year, @as(c_int, 100)) != @as(c_int, 0)) or (@import("std").zig.c_translation.MacroArithmetic.rem(year, @as(c_int, 400)) == @as(c_int, 0)))) {
    _ = &year;
    return (@import("std").zig.c_translation.MacroArithmetic.rem(year, @as(c_int, 4)) == @as(c_int, 0)) and ((@import("std").zig.c_translation.MacroArithmetic.rem(year, @as(c_int, 100)) != @as(c_int, 0)) or (@import("std").zig.c_translation.MacroArithmetic.rem(year, @as(c_int, 400)) == @as(c_int, 0)));
}
pub const CINDEX_VERSION_MAJOR = @as(c_int, 0);
pub const CINDEX_VERSION_MINOR = @as(c_int, 64);
pub inline fn CINDEX_VERSION_ENCODE(major: anytype, minor: anytype) @TypeOf((major * @as(c_int, 10000)) + (minor * @as(c_int, 1))) {
    _ = &major;
    _ = &minor;
    return (major * @as(c_int, 10000)) + (minor * @as(c_int, 1));
}
pub const CINDEX_VERSION = CINDEX_VERSION_ENCODE(CINDEX_VERSION_MAJOR, CINDEX_VERSION_MINOR);
pub const CINDEX_VERSION_STRINGIZE_ = @compileError("unable to translate C expr: unexpected token '#'");
// /usr/include/clang-c/Index.h:44:9
pub inline fn CINDEX_VERSION_STRINGIZE(major: anytype, minor: anytype) @TypeOf(CINDEX_VERSION_STRINGIZE_(major, minor)) {
    _ = &major;
    _ = &minor;
    return CINDEX_VERSION_STRINGIZE_(major, minor);
}
pub const CINDEX_VERSION_STRING = CINDEX_VERSION_STRINGIZE(CINDEX_VERSION_MAJOR, CINDEX_VERSION_MINOR);
pub const CXErrorCode = enum_CXErrorCode;
pub const CXVirtualFileOverlayImpl = struct_CXVirtualFileOverlayImpl;
pub const CXModuleMapDescriptorImpl = struct_CXModuleMapDescriptorImpl;
pub const tm = struct_tm;
pub const timespec = struct_timespec;
pub const itimerspec = struct_itimerspec;
pub const sigevent = struct_sigevent;
pub const __locale_struct = struct___locale_struct;
pub const CXDiagnosticSeverity = enum_CXDiagnosticSeverity;
pub const CXLoadDiag_Error = enum_CXLoadDiag_Error;
pub const CXDiagnosticDisplayOptions = enum_CXDiagnosticDisplayOptions;
pub const CXTargetInfoImpl = struct_CXTargetInfoImpl;
pub const CXTranslationUnitImpl = struct_CXTranslationUnitImpl;
pub const CXUnsavedFile = struct_CXUnsavedFile;
pub const CXAvailabilityKind = enum_CXAvailabilityKind;
pub const CXCursor_ExceptionSpecificationKind = enum_CXCursor_ExceptionSpecificationKind;
pub const CXTranslationUnit_Flags = enum_CXTranslationUnit_Flags;
pub const CXSaveTranslationUnit_Flags = enum_CXSaveTranslationUnit_Flags;
pub const CXSaveError = enum_CXSaveError;
pub const CXReparse_Flags = enum_CXReparse_Flags;
pub const CXTUResourceUsageKind = enum_CXTUResourceUsageKind;
pub const CXCursorKind = enum_CXCursorKind;
pub const CXLinkageKind = enum_CXLinkageKind;
pub const CXVisibilityKind = enum_CXVisibilityKind;
pub const CXLanguageKind = enum_CXLanguageKind;
pub const CXTLSKind = enum_CXTLSKind;
pub const CXCursorSetImpl = struct_CXCursorSetImpl;
pub const CXTypeKind = enum_CXTypeKind;
pub const CXCallingConv = enum_CXCallingConv;
pub const CXTemplateArgumentKind = enum_CXTemplateArgumentKind;
pub const CXTypeNullabilityKind = enum_CXTypeNullabilityKind;
pub const CXTypeLayoutError = enum_CXTypeLayoutError;
pub const CXRefQualifierKind = enum_CXRefQualifierKind;
pub const CX_CXXAccessSpecifier = enum_CX_CXXAccessSpecifier;
pub const CX_StorageClass = enum_CX_StorageClass;
pub const CXChildVisitResult = enum_CXChildVisitResult;
pub const _CXChildVisitResult = struct__CXChildVisitResult;
pub const CXPrintingPolicyProperty = enum_CXPrintingPolicyProperty;
pub const CXNameRefFlags = enum_CXNameRefFlags;
pub const CXCompletionChunkKind = enum_CXCompletionChunkKind;
pub const CXCodeComplete_Flags = enum_CXCodeComplete_Flags;
pub const CXCompletionContext = enum_CXCompletionContext;
pub const CXVisitorResult = enum_CXVisitorResult;
pub const _CXCursorAndRangeVisitorBlock = struct__CXCursorAndRangeVisitorBlock;
pub const CXBinaryOperatorKind = enum_CXBinaryOperatorKind;
pub const CXUnaryOperatorKind = enum_CXUnaryOperatorKind;
