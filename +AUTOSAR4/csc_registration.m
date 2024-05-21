function defs = csc_registration(action)

%   Copyright 1994-2021 The MathWorks, Inc.
%   $Revision: $  $Date: $


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NOTE:
% - This file was automatically generated by the Simulink custom storage class
%   designer.
% - The contents of this file are arranged so that the Simulink custom storage
%   class designer can load the associated classes for editing.
% - Hand modification of this file is not recommended as it may prevent the
%   Simulink custom storage class designer from loading the associated classes.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% - Generated on:   28-Oct-2021 17:20:33
% - MATLAB version: 9.3.0.713579 (R2017b)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


switch action

  case 'CSCDefn'
    defs = [];

    h = Simulink.CSCDefn;
    set(h, 'Name', 'StaticNoIRam');
    set(h, 'OwnerPackage', 'AUTOSAR4');
    set(h, 'CSCType', 'Unstructured');
    set(h, 'MemorySection', 'APP_NOIRAM');
    set(h, 'IsMemorySectionInstanceSpecific', false);
    set(h, 'IsGrouped', false);
        set(h.DataUsage, 'IsParameter', true);
        set(h.DataUsage, 'IsSignal', true);
    set(h, 'DataScope', 'Exported');
    set(h, 'IsDataScopeInstanceSpecific', false);
    set(h, 'IsAutosarPerInstanceMemory', false);
    set(h, 'DataInit', 'None');
    set(h, 'IsDataInitInstanceSpecific', false);
    set(h, 'DataAccess', 'Direct');
    set(h, 'IsDataAccessInstanceSpecific', false);
    set(h, 'HeaderFile', '');
    set(h, 'IsHeaderFileInstanceSpecific', true);
    set(h, 'DefinitionFile', '');
    set(h, 'IsDefinitionFileInstanceSpecific', false);
    set(h, 'Owner', '');
    set(h, 'IsOwnerInstanceSpecific', false);
    set(h, 'IsReusable', false);
    set(h, 'IsReusableInstanceSpecific', false);
    set(h, 'CommentSource', 'Default');
    set(h, 'TypeComment', '');
    set(h, 'DeclareComment', '');
    set(h, 'DefineComment', '');
    set(h, 'CSCTypeAttributesClassName', '');
    set(h, 'CSCTypeAttributes', []);
    set(h, 'TLCFileName', 'Unstructured.tlc');
    defs = [defs; h];

    h = Simulink.CSCDefn;
    set(h, 'Name', 'CalData');
    set(h, 'OwnerPackage', 'AUTOSAR4');
    set(h, 'CSCType', 'Unstructured');
    set(h, 'MemorySection', 'APP_CAL');
    set(h, 'IsMemorySectionInstanceSpecific', false);
    set(h, 'IsGrouped', false);
        set(h.DataUsage, 'IsParameter', true);
        set(h.DataUsage, 'IsSignal', false);
    set(h, 'DataScope', 'Exported');
    set(h, 'IsDataScopeInstanceSpecific', false);
    set(h, 'IsAutosarPerInstanceMemory', false);
    set(h, 'DataInit', 'Auto');
    set(h, 'IsDataInitInstanceSpecific', false);
    set(h, 'DataAccess', 'Direct');
    set(h, 'IsDataAccessInstanceSpecific', false);
    set(h, 'HeaderFile', '');
    set(h, 'IsHeaderFileInstanceSpecific', true);
    set(h, 'DefinitionFile', '');
    set(h, 'IsDefinitionFileInstanceSpecific', false);
    set(h, 'Owner', '');
    set(h, 'IsOwnerInstanceSpecific', true);
    set(h, 'IsReusable', false);
    set(h, 'IsReusableInstanceSpecific', false);
    set(h, 'CommentSource', 'Default');
    set(h, 'TypeComment', '');
    set(h, 'DeclareComment', '');
    set(h, 'DefineComment', '');
    set(h, 'CSCTypeAttributesClassName', '');
    set(h, 'CSCTypeAttributes', []);
    set(h, 'TLCFileName', 'Unstructured.tlc');
    defs = [defs; h];

    h = Simulink.CSCDefn;
    set(h, 'Name', 'StaticNoIRamSafe');
    set(h, 'OwnerPackage', 'AUTOSAR4');
    set(h, 'CSCType', 'Unstructured');
    set(h, 'MemorySection', 'APP_NOIRAM_SAFE');
    set(h, 'IsMemorySectionInstanceSpecific', false);
    set(h, 'IsGrouped', false);
        set(h.DataUsage, 'IsParameter', true);
        set(h.DataUsage, 'IsSignal', true);
    set(h, 'DataScope', 'Exported');
    set(h, 'IsDataScopeInstanceSpecific', false);
    set(h, 'IsAutosarPerInstanceMemory', false);
    set(h, 'DataInit', 'None');
    set(h, 'IsDataInitInstanceSpecific', false);
    set(h, 'DataAccess', 'Direct');
    set(h, 'IsDataAccessInstanceSpecific', false);
    set(h, 'HeaderFile', '');
    set(h, 'IsHeaderFileInstanceSpecific', false);
    set(h, 'DefinitionFile', '');
    set(h, 'IsDefinitionFileInstanceSpecific', false);
    set(h, 'Owner', '');
    set(h, 'IsOwnerInstanceSpecific', false);
    set(h, 'IsReusable', false);
    set(h, 'IsReusableInstanceSpecific', false);
    set(h, 'CommentSource', 'Default');
    set(h, 'TypeComment', '');
    set(h, 'DeclareComment', '');
    set(h, 'DefineComment', '');
    set(h, 'CSCTypeAttributesClassName', '');
    set(h, 'CSCTypeAttributes', []);
    set(h, 'TLCFileName', 'Unstructured.tlc');
    defs = [defs; h];

    h = Simulink.CSCDefn;
    set(h, 'Name', 'GlobalDisp');
    set(h, 'OwnerPackage', 'AUTOSAR4');
    set(h, 'CSCType', 'Unstructured');
    set(h, 'MemorySection', 'APP_DISP');
    set(h, 'IsMemorySectionInstanceSpecific', false);
    set(h, 'IsGrouped', false);
        set(h.DataUsage, 'IsParameter', false);
        set(h.DataUsage, 'IsSignal', true);
    set(h, 'DataScope', 'Exported');
    set(h, 'IsDataScopeInstanceSpecific', false);
    set(h, 'IsAutosarPerInstanceMemory', false);
    set(h, 'DataInit', 'Auto');
    set(h, 'IsDataInitInstanceSpecific', false);
    set(h, 'DataAccess', 'Direct');
    set(h, 'IsDataAccessInstanceSpecific', false);
    set(h, 'HeaderFile', '');
    set(h, 'IsHeaderFileInstanceSpecific', true);
    set(h, 'DefinitionFile', '');
    set(h, 'IsDefinitionFileInstanceSpecific', true);
    set(h, 'Owner', '');
    set(h, 'IsOwnerInstanceSpecific', true);
    set(h, 'IsReusable', false);
    set(h, 'IsReusableInstanceSpecific', true);
    set(h, 'CommentSource', 'Default');
    set(h, 'TypeComment', '');
    set(h, 'DeclareComment', '');
    set(h, 'DefineComment', '');
    set(h, 'CSCTypeAttributesClassName', '');
    set(h, 'CSCTypeAttributes', []);
    set(h, 'TLCFileName', 'Unstructured.tlc');
    defs = [defs; h];

    h = Simulink.CSCDefn;
    set(h, 'Name', 'GlobalDispSafe');
    set(h, 'OwnerPackage', 'AUTOSAR4');
    set(h, 'CSCType', 'Unstructured');
    set(h, 'MemorySection', 'APP_DISP_SAFE');
    set(h, 'IsMemorySectionInstanceSpecific', false);
    set(h, 'IsGrouped', false);
        set(h.DataUsage, 'IsParameter', false);
        set(h.DataUsage, 'IsSignal', true);
    set(h, 'DataScope', 'Exported');
    set(h, 'IsDataScopeInstanceSpecific', false);
    set(h, 'IsAutosarPerInstanceMemory', false);
    set(h, 'DataInit', 'Auto');
    set(h, 'IsDataInitInstanceSpecific', false);
    set(h, 'DataAccess', 'Direct');
    set(h, 'IsDataAccessInstanceSpecific', false);
    set(h, 'HeaderFile', '');
    set(h, 'IsHeaderFileInstanceSpecific', true);
    set(h, 'DefinitionFile', '');
    set(h, 'IsDefinitionFileInstanceSpecific', true);
    set(h, 'Owner', '');
    set(h, 'IsOwnerInstanceSpecific', true);
    set(h, 'IsReusable', false);
    set(h, 'IsReusableInstanceSpecific', true);
    set(h, 'CommentSource', 'Default');
    set(h, 'TypeComment', '');
    set(h, 'DeclareComment', '');
    set(h, 'DefineComment', '');
    set(h, 'CSCTypeAttributesClassName', '');
    set(h, 'CSCTypeAttributes', []);
    set(h, 'TLCFileName', 'Unstructured.tlc');
    defs = [defs; h];

    h = Simulink.CSCDefn;
    set(h, 'Name', 'GlobalNvm');
    set(h, 'OwnerPackage', 'AUTOSAR4');
    set(h, 'CSCType', 'Unstructured');
    set(h, 'MemorySection', 'APP_NVM');
    set(h, 'IsMemorySectionInstanceSpecific', false);
    set(h, 'IsGrouped', false);
        set(h.DataUsage, 'IsParameter', true);
        set(h.DataUsage, 'IsSignal', true);
    set(h, 'DataScope', 'Exported');
    set(h, 'IsDataScopeInstanceSpecific', false);
    set(h, 'IsAutosarPerInstanceMemory', false);
    set(h, 'DataInit', 'Auto');
    set(h, 'IsDataInitInstanceSpecific', false);
    set(h, 'DataAccess', 'Direct');
    set(h, 'IsDataAccessInstanceSpecific', false);
    set(h, 'HeaderFile', '');
    set(h, 'IsHeaderFileInstanceSpecific', true);
    set(h, 'DefinitionFile', '');
    set(h, 'IsDefinitionFileInstanceSpecific', true);
    set(h, 'Owner', '');
    set(h, 'IsOwnerInstanceSpecific', true);
    set(h, 'IsReusable', false);
    set(h, 'IsReusableInstanceSpecific', false);
    set(h, 'CommentSource', 'Default');
    set(h, 'TypeComment', '');
    set(h, 'DeclareComment', '');
    set(h, 'DefineComment', '');
    set(h, 'CSCTypeAttributesClassName', '');
    set(h, 'CSCTypeAttributes', []);
    set(h, 'TLCFileName', 'Unstructured.tlc');
    defs = [defs; h];

    h = Simulink.CSCDefn;
    set(h, 'Name', 'GlobalNvmSafe');
    set(h, 'OwnerPackage', 'AUTOSAR4');
    set(h, 'CSCType', 'Unstructured');
    set(h, 'MemorySection', 'APP_NVM_SAFE');
    set(h, 'IsMemorySectionInstanceSpecific', false);
    set(h, 'IsGrouped', false);
        set(h.DataUsage, 'IsParameter', true);
        set(h.DataUsage, 'IsSignal', true);
    set(h, 'DataScope', 'Exported');
    set(h, 'IsDataScopeInstanceSpecific', false);
    set(h, 'IsAutosarPerInstanceMemory', false);
    set(h, 'DataInit', 'Auto');
    set(h, 'IsDataInitInstanceSpecific', false);
    set(h, 'DataAccess', 'Direct');
    set(h, 'IsDataAccessInstanceSpecific', false);
    set(h, 'HeaderFile', '');
    set(h, 'IsHeaderFileInstanceSpecific', true);
    set(h, 'DefinitionFile', '');
    set(h, 'IsDefinitionFileInstanceSpecific', true);
    set(h, 'Owner', '');
    set(h, 'IsOwnerInstanceSpecific', true);
    set(h, 'IsReusable', false);
    set(h, 'IsReusableInstanceSpecific', false);
    set(h, 'CommentSource', 'Default');
    set(h, 'TypeComment', '');
    set(h, 'DeclareComment', '');
    set(h, 'DefineComment', '');
    set(h, 'CSCTypeAttributesClassName', '');
    set(h, 'CSCTypeAttributes', []);
    set(h, 'TLCFileName', 'Unstructured.tlc');
    defs = [defs; h];

    h = Simulink.CSCDefn;
    set(h, 'Name', 'Custom');
    set(h, 'OwnerPackage', 'AUTOSAR4');
    set(h, 'CSCType', 'Unstructured');
    set(h, 'MemorySection', 'Default');
    set(h, 'IsMemorySectionInstanceSpecific', true);
    set(h, 'IsGrouped', false);
        set(h.DataUsage, 'IsParameter', true);
        set(h.DataUsage, 'IsSignal', true);
    set(h, 'DataScope', 'Auto');
    set(h, 'IsDataScopeInstanceSpecific', false);
    set(h, 'IsAutosarPerInstanceMemory', false);
    set(h, 'DataInit', 'Auto');
    set(h, 'IsDataInitInstanceSpecific', false);
    set(h, 'DataAccess', 'Direct');
    set(h, 'IsDataAccessInstanceSpecific', false);
    set(h, 'HeaderFile', '');
    set(h, 'IsHeaderFileInstanceSpecific', true);
    set(h, 'DefinitionFile', '');
    set(h, 'IsDefinitionFileInstanceSpecific', false);
    set(h, 'Owner', '');
    set(h, 'IsOwnerInstanceSpecific', false);
    set(h, 'IsReusable', false);
    set(h, 'IsReusableInstanceSpecific', false);
    set(h, 'CommentSource', 'Default');
    set(h, 'TypeComment', '');
    set(h, 'DeclareComment', '');
    set(h, 'DefineComment', '');
    set(h, 'CSCTypeAttributesClassName', '');
    set(h, 'CSCTypeAttributes', []);
    set(h, 'TLCFileName', 'Unstructured.tlc');
    defs = [defs; h];

  case 'MemorySectionDefn'
    defs = [];

    h = Simulink.MemorySectionRefDefn;
    set(h, 'Name', 'APP_RUN');
    set(h, 'OwnerPackage', 'AUTOSAR4');
    set(h, 'RefPackageName', 'AUTOSAR');
    set(h, 'RefDefnName', 'SwAddrMethod');
    defs = [defs; h];

    h = Simulink.MemorySectionRefDefn;
    set(h, 'Name', 'APP_RUN_SAFE');
    set(h, 'OwnerPackage', 'AUTOSAR4');
    set(h, 'RefPackageName', 'AUTOSAR');
    set(h, 'RefDefnName', 'SwAddrMethod');
    defs = [defs; h];

    h = Simulink.MemorySectionRefDefn;
    set(h, 'Name', 'APP_NOIRAM');
    set(h, 'OwnerPackage', 'AUTOSAR4');
    set(h, 'RefPackageName', 'AUTOSAR');
    set(h, 'RefDefnName', 'SwAddrMethod');
    defs = [defs; h];

    h = Simulink.MemorySectionRefDefn;
    set(h, 'Name', 'APP_NOIRAM_SAFE');
    set(h, 'OwnerPackage', 'AUTOSAR4');
    set(h, 'RefPackageName', 'AUTOSAR');
    set(h, 'RefDefnName', 'SwAddrMethod');
    defs = [defs; h];

    h = Simulink.MemorySectionRefDefn;
    set(h, 'Name', 'APP_NVM');
    set(h, 'OwnerPackage', 'AUTOSAR4');
    set(h, 'RefPackageName', 'AUTOSAR');
    set(h, 'RefDefnName', 'SwAddrMethod');
    defs = [defs; h];

    h = Simulink.MemorySectionRefDefn;
    set(h, 'Name', 'APP_NVM_SAFE');
    set(h, 'OwnerPackage', 'AUTOSAR4');
    set(h, 'RefPackageName', 'Simulink');
    set(h, 'RefDefnName', 'Default');
    defs = [defs; h];

    h = Simulink.MemorySectionRefDefn;
    set(h, 'Name', 'APP_DISP');
    set(h, 'OwnerPackage', 'AUTOSAR4');
    set(h, 'RefPackageName', 'AUTOSAR');
    set(h, 'RefDefnName', 'SwAddrMethod');
    defs = [defs; h];

    h = Simulink.MemorySectionRefDefn;
    set(h, 'Name', 'APP_CAL');
    set(h, 'OwnerPackage', 'AUTOSAR4');
    set(h, 'RefPackageName', 'AUTOSAR');
    set(h, 'RefDefnName', 'SwAddrMethod_Const_Volatile');
    defs = [defs; h];

    h = Simulink.MemorySectionRefDefn;
    set(h, 'Name', 'APP_DISP_SAFE');
    set(h, 'OwnerPackage', 'AUTOSAR4');
    set(h, 'RefPackageName', 'AUTOSAR');
    set(h, 'RefDefnName', 'SwAddrMethod');
    defs = [defs; h];

  otherwise
    DAStudio.error('Simulink:dialog:CSCRegInvalidAction', action);
end  % switch action


%EOF