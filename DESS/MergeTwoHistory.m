function History_SASSMODE=MergeTwoHistory(History_SASS,History_MODE)

History_SASSMODE.pop=[History_SASS.pop,History_MODE.pop];
History_SASSMODE.obj=[History_SASS.obj,History_MODE.obj];
History_SASSMODE.con=[History_SASS.con,History_MODE.con];
History_SASSMODE.iter=History_SASS.iter+History_MODE.iter;