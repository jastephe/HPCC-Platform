/*##############################################################################

    HPCC SYSTEMS software Copyright (C) 2012 HPCC Systems.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
############################################################################## */

//UseStandardFiles
//UseIndexes

// try it with just one limit

o1 := output(LIMIT(DG_FetchIndex1(Lname='Anderson'),1,SKIP), {fname});
o2 := output(LIMIT(DG_FetchIndex1(Lname='Anderson'),10,SKIP), {fname});
o3 := output(LIMIT(DG_FetchIndex1(Lname='Anderson'),1,SKIP,KEYED), {fname});
o4 := output(LIMIT(DG_FetchIndex1(Lname='Anderson'),10,SKIP,KEYED), {fname});

// hack to get around codegen optimizing platform(),once call into global (and therefore hthor) context.
nononcelib := 
    SERVICE
varstring platform() : library='graph', include='eclhelper.hpp', ctxmethod, entrypoint='getPlatform';
    END;

iresult := DG_FetchIndex1(Lname IN ['Anderson', 'Taylor']);
lkresult := LIMIT(iresult,10,KEYED);
lsresult := LIMIT(lkresult,10,SKIP);
sresult := IF(nononcelib.platform() != 'hthor', SORT(lsresult,Lname), lsresult);
o5 := output(sresult, {fname});

// then try with a keyed and unkeyed....



o6 := output(LIMIT(LIMIT(DG_FetchIndex1(Lname='Anderson'),1,SKIP,keyed),1,skip), {fname});
o7 := output(LIMIT(LIMIT(DG_FetchIndex1(Lname='Anderson'),10,SKIP,keyed),10,skip), {fname});

 o1:independent;
 o2:independent;
 o3:independent;
 o4:independent;
 o5:independent;
 o6:independent;
 o7:independent;
