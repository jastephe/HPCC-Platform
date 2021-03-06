################################################################################
#    HPCC SYSTEMS software Copyright (C) 2012 HPCC Systems.
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
################################################################################

# Component: esdl 

#####################################################
# Description:
# ------------
#    Cmake Input File for esdl
#####################################################


project( esdl ) 

include_directories ( 
         ./../../system/include 
         ./../../system/jlib 
    )

ADD_DEFINITIONS ( -D_CONSOLE )

add_custom_command ( OUTPUT esdlgram.cpp esdlgram.h
    COMMAND ../pcyacc/pcyacc -v -Desdlgram.h -Cesdlgram.cpp hidlgram.y
    DEPENDS esdlgram.h
)

add_custom_command ( OUTPUT esdllex.cpp 
    COMMAND ../pcyacc/pclex -i -Cesdllex.cpp esdllex.l
    DEPENDS esdllex.l
)

set ( SRCS esdlgram.cpp esdllex.cpp main.cpp esdlcomp.cpp esdl_utils.cpp )
# esdlgram.y esdllex.l main.cpp esdlcomp.cpp esdl_utils.cpp 
HPCC_ADD_EXECUTABLE ( esdl ${SRCS} )
install ( TARGETS esdl RUNTIME DESTINATION ${EXEC_DIR} )
#add_dependencies ( esdl esdlgram.cpp esdlgram.h esdllex.cpp )

