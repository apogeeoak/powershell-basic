### Module manifest.

@{
    RootModule           = 'Apogee.Basic.psm1'
    NestedModules        = @('Apogee.Implement.psm1')
    ModuleVersion        = '1.0.0'
    CompatiblePSEditions = @('Core')
    GUID                 = '75e6fa26-f28a-4112-94f5-32b445d517f1'
    Author               = 'Apogee'
    Copyright            = 'Copyright (c) Apogee. All rights reserved.'
    Description          = 'Basic library functions.'
    CmdletsToExport      = @()
    VariablesToExport    = @()
    FunctionsToExport    =
        'Add-Path',
        'Compare-FileHash',
        'Get-UserModule',
        'Import-UserModule',
        'New-SymbolicLink',
        'Rename-Extension',
        'Reset-Path',
        'Switch-Path'
    AliasesToExport      =
        'hash',
        'ln',
        'reimport',
        'wo'
}
