/*
 *  PTTokyoTypes.h
 *  Prismo
 *
 *  Created by Sergey Lenkov on 05.01.11.
 *  Copyright 2011 Positive Team. All rights reserved.
 *
 */

typedef enum {
    TCStringEqual = TDBQCSTREQ,
    TCStringIncude = TDBQCSTRINC,
    TCStringBegin = TDBQCSTRBW,
    TCStringEnd = TDBQCSTREW,
    TCStringIncludeAll = TDBQCSTRAND,
    TCStringIncludeOne = TDBQCSTROR,
    TCStringEqualOne = TDBQCSTROREQ,
    TCStringEqualRegex = TDBQCSTRRX,
    TCNumberEqual = TDBQCNUMEQ,
    TCNumberGreater = TDBQCNUMGT,
    TCNumberGreaterOrEqual = TDBQCNUMGE,
    TCNumberLess = TDBQCNUMLT,
    TCNumberLessOrEqual = TDBQCNUMLE,
    TCNumberBeeween = TDBQCNUMBT,
    TCNumberEqualOne = TDBQCNUMOREQ 
} PTTokyoConditionTypes;

typedef enum {
    TOStringAscending = TDBQOSTRASC,
    TOStringDescending = TDBQOSTRDESC,
    TONumberAscending = TDBQONUMASC,
    TONumberDescending = TDBQONUMDESC
} PTTokyoOrderTypes;