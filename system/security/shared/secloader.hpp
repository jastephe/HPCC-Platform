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

#ifndef _SECLOADER_HPP__
#define _SECLOADER_HPP__
#include "seclib.hpp"

#ifdef _WIN32
#define LDAPSECLIB "LdapSecurity.dll"
#else
#define LDAPSECLIB "libLdapSecurity.so"
#endif

typedef IAuthMap* (*createDefaultAuthMap_t_)(IPropertyTree* config);
typedef ISecManager* (*newSecManager_t_)(const char *serviceName, IPropertyTree &config);

class SecLoader
{
public:
    static ISecManager* loadSecManager(const char* model_name, const char* servicename, IPropertyTree* cfg)
    {
        if(model_name && stricmp(model_name, "LdapSecurity") == 0)
        {
            HINSTANCE ldapseclib = LoadSharedObject(LDAPSECLIB, true, false);
            if(ldapseclib == NULL)
                throw MakeStringException(-1, "can't load library %s", LDAPSECLIB);
            
            newSecManager_t_ xproc = NULL;
            xproc = (newSecManager_t_)GetSharedProcedure(ldapseclib, "newLdapSecManager");

            if (xproc)
                return xproc(servicename, *cfg);
            else
                throw MakeStringException(-1, "procedure newLdapSecManager of %s can't be loaded", LDAPSECLIB);
        }
        else if(model_name && stricmp(model_name, "Local") == 0)
        {
            HINSTANCE ldapseclib = LoadSharedObject(LDAPSECLIB, true, false);
            if(ldapseclib == NULL)
                throw MakeStringException(-1, "can't load library %s", LDAPSECLIB);
            
            newSecManager_t_ xproc = NULL;
            xproc = (newSecManager_t_)GetSharedProcedure(ldapseclib, "newLocalSecManager");

            if (xproc)
                return xproc(servicename, *cfg);
            else
                throw MakeStringException(-1, "procedure newLocalSecManager of %s can't be loaded", LDAPSECLIB);
        }
        else if(model_name && stricmp(model_name, "Default") == 0)
        {
            HINSTANCE ldapseclib = LoadSharedObject(LDAPSECLIB, true, false);
            if(ldapseclib == NULL)
                throw MakeStringException(-1, "can't load library %s", LDAPSECLIB);
            
            newSecManager_t_ xproc = NULL;
            xproc = (newSecManager_t_)GetSharedProcedure(ldapseclib, "newDefaultSecManager");

            if (xproc)
                return xproc(servicename, *cfg);
            else
                throw MakeStringException(-1, "procedure newDefaultSecManager of %s can't be loaded", LDAPSECLIB);
        }
        else
            throw MakeStringException(-1, "Security model %s not supported", model_name?model_name:"UNKNOWN");
    }   

    static IAuthMap* loadTheDefaultAuthMap(IPropertyTree* cfg)
    {
        HINSTANCE seclib = LoadSharedObject(LDAPSECLIB, true, false);       // ,false,true may actually be more helpful.
        if(seclib == NULL)
            throw MakeStringException(-1, "can't load library %s", LDAPSECLIB);

        createDefaultAuthMap_t_ xproc = NULL;
        xproc = (createDefaultAuthMap_t_)GetSharedProcedure(seclib, "newDefaultAuthMap");

        if (xproc)
            return xproc(cfg);
        else
            throw MakeStringException(-1, "procedure newDefaultAuthMap of %s can't be loaded", LDAPSECLIB);
    }   
};

#endif
