Attribute VB_Name = "Module2"
Sub form_c_prep_csvs()
Attribute form_c_prep_csvs.VB_ProcData.VB_Invoke_Func = " \n14"
'
' form_c_prep_csvs Macro
'

'
    Sheets("Hluvukani_c_V1").Select
    Range(Selection, Cells(1)).Select
    Range(Selection, Selection.End(xlToRight)).Select
    Range(Selection, Selection.End(xlDown)).Select
    Selection.Copy
    Workbooks.Add
    ActiveSheet.Paste
    Range("B:B,C:C").Select
    Range("C1").Activate
    Range("B:B,C:C,AQ:AQ").Select
    Range("AQ1").Activate
    Application.CutCopyMode = False
    Selection.NumberFormat = "dd/mm/yyyy hh:mm"
    Columns("G:G").Select
    Selection.NumberFormat = "dd/mm/yyyy"
    Range("A1").Select
    ActiveWorkbook.SaveAs Filename:= _
        "Y:\projects\illovo\dbupdate\Hluvukani_C_parcelas.csv", FileFormat:=xlCSV, _
        CreateBackup:=False
    ActiveWindow.Close
    Range("hluvukani_c_v1[[#Headers],[geom]]").Select
    Sheets("Titulares").Select
    Range("Titulares[[#Headers],[parentuid]]").Select
    Range(Selection, Selection.End(xlToRight)).Select
    Range(Selection, Selection.End(xlDown)).Select
    Selection.Copy
    Workbooks.Add
    ActiveSheet.Paste
    Application.CutCopyMode = False
    ActiveWorkbook.SaveAs Filename:= _
        "Y:\projects\illovo\dbupdate\Hluvukani_C_titulars.csv", FileFormat:=xlCSV, _
        CreateBackup:=False
    ActiveWindow.Close
    Range("Titulares[[#Headers],[parentuid]]").Select
    Sheets("Novas_pessoas").Select
    Range("A3").Select
    ActiveCell.FormulaR1C1 = "=R[-1]C+1"
    Range("B4").Select
    Selection.End(xlDown).Select
    Selection.End(xlToLeft).Select
    Range(Selection, Selection.End(xlUp)).Select
    Range("A3:A236").Select
    Range("A236").Activate
    Selection.FillDown
    Selection.End(xlToRight).Select
    Range("X236").Select
    Selection.End(xlToRight).Select
    Range(Selection, Selection.End(xlUp)).Select
    Range("Novas_pessoas[confirmado]").Select
    Range("Y236").Activate
    Selection.FillDown
    Range("Y236").Select
    Range(Selection, Cells(1)).Select
    Selection.Copy
    Workbooks.Add
    ActiveSheet.Paste
    Range("L:L,Q:Q,R:R").Select
    Range("Novas_pessoas[[#Headers],[docval]]").Activate
    Application.CutCopyMode = False
    Selection.NumberFormat = "dd/mm/yyyy"
    Range("L2").Select
    Selection.AutoFilter
    Range("Novas_pessoas[[#Headers],[id]]").Select
    ActiveWindow.SmallScroll Down:=-3
    ActiveWorkbook.SaveAs Filename:= _
        "Y:\projects\illovo\dbupdate\Hluvukani_C_novas_pessoas.csv", FileFormat:= _
        xlCSV, CreateBackup:=False
    ActiveWindow.Close
    Sheets("Testemunhas").Select
    Range("Testemunhas[[#Headers],[parentuid]]").Select
    Range(Selection, Selection.End(xlToRight)).Select
    Range(Selection, Selection.End(xlDown)).Select
    Selection.Copy
    Workbooks.Add
    ActiveSheet.Paste
    Application.CutCopyMode = False
    ActiveWorkbook.SaveAs Filename:= _
        "Y:\projects\illovo\dbupdate\Hluvukani_C_testemunhas.csv", FileFormat:=xlCSV _
        , CreateBackup:=False
    ActiveWindow.Close
    Range("Testemunhas[[#Headers],[parentuid]]").Select
    Sheets("Pontos").Select
    Range("Points[[#Headers],[geom]]").Select
    Range(Selection, Selection.End(xlToRight)).Select
    Range(Selection, Selection.End(xlDown)).Select
    Selection.Copy
    Workbooks.Add
    ActiveSheet.Paste
    Application.CutCopyMode = False
    ActiveWorkbook.SaveAs Filename:= _
        "Y:\projects\illovo\dbupdate\Hluvukani_C_pontos.csv", FileFormat:=xlCSV, _
        CreateBackup:=False
    ActiveWindow.Close
    Range("Points[[#Headers],[geom]]").Select
    ActiveWorkbook.Save
End Sub
