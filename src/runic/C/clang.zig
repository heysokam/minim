//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
pub const clang = @This();

// @deps zstd
const zstr = zstd.zstr;
const zstd = struct {
  // @deps std
  const std = @import("std");
  const zstr = [:0]const u8;
  pub fn T (comptime F :type, comptime I :type) type {
    comptime std.debug.assert(@sizeOf(F)    == @sizeOf(I)   );
    // comptime std.debug.assert(@bitSizeOf(F) == @bitSizeOf(I));
    return struct {
      pub fn toInt   (v :F      ) I    { return @bitCast(v); }
      pub fn fromInt (v :I      ) F    { return @bitCast(v); }
      pub fn with    (a :F, b :F) F    { return fromInt(toInt(a) | toInt(b)); }
      pub fn only    (a :F, b :F) F    { return fromInt(toInt(a) & toInt(b)); }
      pub fn without (a :F, b :F) F    { return fromInt(toInt(a) & ~toInt(b)); }
      pub fn hasAll  (a :F, b :F) bool { return (toInt(a) & toInt(b)) == toInt(b); }
      pub fn hasAny  (a :F, b :F) bool { return (toInt(a) & toInt(b)) != 0; }
      pub fn isEmpty (a :F      ) bool { return toInt(a) == 0; }
    };
  }
};

const C = struct {
  const c = @import("../lib/clang.zig");

  //______________________________________
  // @section C: General Tools
  //____________________________
  pub const UserData = c.CXClientData;

  //______________________________________
  // @section C: Errors
  //____________________________
  pub const ErrCode = c.CXErrorCode;
  pub const Error = enum(C.ErrCode) {
    ok          = 0, // CXError_Success          :c_int=  0;
    failure     = 1, // CXError_Failure          :c_int=  1;
    crashed     = 2, // CXError_Crashed          :c_int=  2;
    invalidArgs = 3, // CXError_InvalidArguments :c_int=  3;
    astReadErr  = 4, // CXError_ASTReadError     :c_int=  4;
  }; //:: clang.C.Error


  //______________________________________
  // @section C: Compilation Index
  //____________________________
  const Index     = clang.C.index.T;
  const index     = struct {
    const T       = c.CXIndex;
    const create  = c.clang_createIndex;
    const destroy = c.clang_disposeIndex;
  };


  //______________________________________
  // @section C: Translation Unit
  //____________________________
  const TranslationUnit = C.translationUnit.T;
  const translationUnit = struct {
    const T         = c.CXTranslationUnit;
    const parse1    = c.clang_parseTranslationUnit;
    const parse     = c.clang_parseTranslationUnit2;
    const parseArgv = c.clang_parseTranslationUnit2FullArgv;
    const reparse   = c.clang_reparseTranslationUnit;
    const Suspend   = c.clang_suspendTranslationUnit;
    const destroy   = c.clang_disposeTranslationUnit;
    const is        = c.clang_isTranslationUnit;
    const create    = c.clang_createTranslationUnitFromSourceFile;
    const defaults  = c.clang_defaultEditingTranslationUnitOptions;
    pub const get   = struct {
      const cursor  = c.clang_getTranslationUnitCursor;
      const spell   = c.clang_getTranslationUnitSpelling;
    };  //:: clang.C.tu.get
    pub const Flags = packed struct {
      detailedProcessingRecord             :bool =  false,  // 00 :: CXTranslationUnit_DetailedPreprocessingRecord          :c_int=  1;
      incomplete                           :bool =  false,  // 01 :: CXTranslationUnit_Incomplete                           :c_int=  2;
      precompiledPreamble                  :bool =  false,  // 02 :: CXTranslationUnit_PrecompiledPreamble                  :c_int=  4;
      cacheCompletionResults               :bool =  false,  // 03 :: CXTranslationUnit_CacheCompletionResults               :c_int=  8;
      forSerialization                     :bool =  false,  // 04 :: CXTranslationUnit_ForSerialization                     :c_int=  16;
      cXXChainedPCH                        :bool =  false,  // 05 :: CXTranslationUnit_CXXChainedPCH                        :c_int=  32;
      skipFunctionBodies                   :bool =  false,  // 06 :: CXTranslationUnit_SkipFunctionBodies                   :c_int=  64;
      includeBriefCommentsInCodeCompletion :bool =  false,  // 06 :: CXTranslationUnit_IncludeBriefCommentsInCodeCompletion :c_int=  128;
      createPreambleOnFirstParse           :bool =  false,  // 08 :: CXTranslationUnit_CreatePreambleOnFirstParse           :c_int=  256;
      keepGoing                            :bool =  false,  // 09 :: CXTranslationUnit_KeepGoing                            :c_int=  512;
      singleFileParse                      :bool =  false,  // 10 :: CXTranslationUnit_SingleFileParse                      :c_int=  1024;
      limitSkipFunctionBodiesToPreamble    :bool =  false,  // 11 :: CXTranslationUnit_LimitSkipFunctionBodiesToPreamble    :c_int=  2048;
      includeAttributedTypes               :bool =  false,  // 12 :: CXTranslationUnit_IncludeAttributedTypes               :c_int=  4096;
      visitImplicitAttributes              :bool =  false,  // 13 :: CXTranslationUnit_VisitImplicitAttributes              :c_int=  8192;
      ignoreNonErrorsFromIncludedFiles     :bool =  false,  // 14 :: CXTranslationUnit_IgnoreNonErrorsFromIncludedFiles     :c_int=  16384;
      retainExcludedConditionalBlocks      :bool =  false,  // 15 :: CXTranslationUnit_RetainExcludedConditionalBlocks      :c_int=  32768;
      __reserved_bits_16_31 :u16=0,
      pub usingnamespace zstd.Flags(@This(), c.CXTranslationUnit_Flags);
      pub const none = clang.C.translationUnit.Flags{}; // CXTranslationUnit_None  :c_int=  0;
    };
  }; //:: clang.C.tu


  //______________________________________
  // @section C: AST Cursor
  //____________________________
  pub const Cursor = clang.C.cursor.T;
  pub const cursor = struct {
    pub const T = c.CXCursor;
    pub const visit = struct {
    };
  }; //:: clang.C.cursor

  pub const visit = struct {
    pub const ResultCode = c.CXChildVisitResult;
    pub const Result     = enum(ResultCode) {
      Break              = 0,  // CXChildVisit_Break    :c_int=  0;
      Continue           = 1,  // CXChildVisit_Continue :c_int=  1;
      Recurse            = 2,  // CXChildVisit_Recurse  :c_int=  2;
    }; //:: clang.C.visit.Result
    pub const Fn  = ?*const fn (C.Cursor, C.Cursor, C.UserData) callconv(.C) C.visit.Result;
    extern fn clang_visitChildren (parent: C.Cursor, visitor: C.visit.Fn, userdata: C.UserData) C.visit.Result;
    pub const children = clang_visitChildren;
    pub const childrenWithBlock = c.clang_visitChildrenWithBlock;
  }; //:: clang.C.visit


  //______________________________________
  // @section C: Diagnostics
  //____________________________
  pub const diagnostics = struct {
  }; //:: clang.C.diagnostics
}; //:: clang.C


//______________________________________
// @section General Tools
//____________________________
pub const UserData = clang.C.UserData;


//______________________________________
// @section C: Errors
//____________________________
pub fn ok (R :clang.C.ErrCode) !void {
  const code :C.Error= @enumFromInt(R);
  switch (code) {
    C.Error.ok          => {},
    C.Error.failure     => return error.Failure,
    C.Error.crashed     => return error.Crashed,
    C.Error.invalidArgs => return error.InvalidArgs,
    C.Error.astReadErr  => return error.ASTReadError,
  }
} //:: clang.ok


//______________________________________
// @section Compilation Index
//____________________________
/// @descr Set of translation units that are linked together into an executable or library.
pub const Index = struct {
  ct  :C.Index,

  pub const CreateOptions = struct {
    excludeDeclarationsFromPCH :bool= false,
    displayDiagnostics         :bool= false,
  }; //:: clang.Index.CreateOptions
  pub fn create2 (
      in : clang.Index.CreateOptions
    ) clang.Index {
    return clang.Index{.ct = C.index.create(@intFromBool(in.excludeDeclarationsFromPCH), @intFromBool(in.displayDiagnostics))};
  } //:: clang.Index.create
  pub fn create () clang.Index { return clang.Index.create2(.{}); }

  pub fn destroy (I :*const clang.Index) void { clang.C.index.destroy(I.ct); }
}; //:: clang.Index



//______________________________________
// @section Translation Unit
//____________________________
/// @descr A single translation unit. Resides in an index.
pub const TranslationUnit = struct {
  ct : C.TranslationUnit,
  pub const Flags = clang.C.translationUnit.Flags;
  pub fn parse (
      I     : clang.Index,
      path  : zstr,
      flags : clang.TranslationUnit.Flags,
    ) !clang.TranslationUnit {
    var result :clang.TranslationUnit= undefined;
    try clang.ok(clang.C.translationUnit.parse(
      I.ct,          // Index
      path.ptr,      // File Path
      null,          // CLI arguments
      0,             // CLI count
      null,          // Unsaved Files
      0,             // Unsaved Files count
      flags.toInt(), // clang.C.tu
      &result.ct,    // Result
      ));
    return result;
  } //:: clang.TU.parse

  pub fn getCursor (tu :*const clang.TranslationUnit) clang.C.Cursor { return clang.C.translationUnit.get.cursor(tu.ct); }
  pub fn destroy (tu :*const clang.TranslationUnit) void { clang.C.translationUnit.destroy(tu.ct); }
}; //:: clang.TU


//______________________________________
// @section AST Navigation
//____________________________
pub const visit = struct {
  pub const Fn     = clang.C.visit.Fn;
  pub const Result = clang.C.visit.Result;
  pub const Cursor = clang.C.Cursor;
  pub const Data   = clang.C.UserData;

  //______________________________________
  /// @descr
  ///   Visit the direct children of the {@arg cursor} cursor.
  ///   Will call the {@arg F} function on the cursors of each visited child.
  ///   Traversal will be recursive if the function returns {@link clang.visit.Result.Break}.
  ///   Traversal may end prematurely if the visitor returns {@link clang.visit.Result.Break}.
  ///
  /// @arg N The cursor whose childen will be visited. All kinds of cursors can be visited, including invalid cursors (which, by definition, have no children).
  /// @arg F the function that will be called for each child of the parent.
  /// @arg D Pointer to arbitrary data supplied by the client. Will be passed to the visitor each time it is called.
  /// @res Whether or not traversal terminated prematurely by the visitor returning {@link clang.visit.Result.Break}
  pub fn children (
      N : *const clang.Cursor,
      D : clang.UserData,
      F : clang.visit.Fn,
    ) bool {
    return clang.C.visit.children(N.ct, F, D) != .Break;
  }
}; //:: clang.visit


//______________________________________
// @section AST Cursor
//____________________________
/// @descr Represents a pointer to some element in the abstract syntax tree of a translation unit.
pub const Cursor = struct {
  ct : C.Cursor,
  pub fn create (
      tu : clang.TranslationUnit,
    ) clang.Cursor {
    return clang.Cursor{.ct = tu.getCursor()};
  }
  pub const visitChildren = clang.visit.children;
  // pub const visitChildrenWithBlock = clang.visit.childrenWithBlock;
}; //:: clang.Cursor

