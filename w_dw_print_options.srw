$PBExportHeader$w_dw_print_options.srw
$PBExportComments$New! Datawindow print options
forward
global type w_dw_print_options from window
end type
type cbx_draft from checkbox within w_dw_print_options
end type
type cb_file from picturebutton within w_dw_print_options
end type
type cb_printer from picturebutton within w_dw_print_options
end type
type cb_cancel from picturebutton within w_dw_print_options
end type
type cb_ok from picturebutton within w_dw_print_options
end type
type st_print_file from statictext within w_dw_print_options
end type
type st_pf from statictext within w_dw_print_options
end type
type ddlb_range from dropdownlistbox within w_dw_print_options
end type
type st_4 from statictext within w_dw_print_options
end type
type cbx_collate from checkbox within w_dw_print_options
end type
type cbx_print_to_file from checkbox within w_dw_print_options
end type
type st_3 from statictext within w_dw_print_options
end type
type sle_page_range from singlelineedit within w_dw_print_options
end type
type rb_pages from radiobutton within w_dw_print_options
end type
type rb_current_page from radiobutton within w_dw_print_options
end type
type rb_all from radiobutton within w_dw_print_options
end type
type em_copies from editmask within w_dw_print_options
end type
type st_2 from statictext within w_dw_print_options
end type
type sle_printer from singlelineedit within w_dw_print_options
end type
type st_1 from statictext within w_dw_print_options
end type
type gb_1 from groupbox within w_dw_print_options
end type
end forward

global type w_dw_print_options from window
integer x = 457
integer y = 368
integer width = 2007
integer height = 1180
boolean titlebar = true
string title = "Setup Printer"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 12632256
cbx_draft cbx_draft
cb_file cb_file
cb_printer cb_printer
cb_cancel cb_cancel
cb_ok cb_ok
st_print_file st_print_file
st_pf st_pf
ddlb_range ddlb_range
st_4 st_4
cbx_collate cbx_collate
cbx_print_to_file cbx_print_to_file
st_3 st_3
sle_page_range sle_page_range
rb_pages rb_pages
rb_current_page rb_current_page
rb_all rb_all
em_copies em_copies
st_2 st_2
sle_printer sle_printer
st_1 st_1
gb_1 gb_1
end type
global w_dw_print_options w_dw_print_options

type variables
string is_page_range
datawindow idw_dw
end variables

forward prototypes
private subroutine wf_page_range (radiobutton who)
public subroutine wf_enable_printfile ()
public subroutine wf_disable_printfile ()
end prototypes

private subroutine wf_page_range (radiobutton who);//****************************************************************************************************************
// Name : wf_page_range
// Purpose : choose page range
// Return : 
// Author : 
// Date Created : 
// Date Updated : 
// Change Summary : 
//*****************************************************************************************************************

choose case who
	case rb_all
		sle_page_range.text = ''
		sle_page_range.enabled = false
		is_page_range = 'a'
	case rb_current_page
		sle_page_range.text = ''
		sle_page_range.enabled = false
		is_page_range = 'c'
	case rb_pages
		sle_page_range.enabled = true
		is_page_range = 'p'
end choose
end subroutine

public subroutine wf_enable_printfile ();//****************************************************************************************************************
// Name : wf_enable_printfile
// Purpose : show all items related to choosing a file
// Return : 
// Author : 
// Date Created : 
// Date Updated : 
// Change Summary : 
//*****************************************************************************************************************


st_pf.visible = true
st_print_file.visible = true
cb_file.visible = true
end subroutine

public subroutine wf_disable_printfile ();//****************************************************************************************************************
// Name : wf_disable_printfile
// Purpose : hide all items related to choosing a file
// Return : 
// Author : 
// Date Created : 
// Date Updated : 
// Change Summary : 
//*****************************************************************************************************************


st_pf.visible = false
st_print_file.visible = false
cb_file.visible = false
st_print_file.text = ''
end subroutine

event open;//****************************************************************************************************************
// Name : Print Options
// Purpose : we assume that this window will be opened using openwitparm and that a datawindow control will be passed to it
// Return : 
// Author : 
// Date Created : 
// Date Updated : 
// Change Summary : 
//*****************************************************************************************************************
string ls_rc

//addy 10/17/2012 error ticket
gs_windowname= This.ClassName()


idw_dw = message.powerobjectparm
sle_printer.text = idw_dw.describe('datawindow.printer')

//set the page print include (all,even,odd)

ls_rc = idw_dw.Describe('datawindow.print.page.rangeinclude')

choose case Left(ls_rc,1)  // determine rangeinclude (all,even,odd)
	case '0' // all
		ddlb_range.SelectItem(1) 
		is_page_range = 'a'
	case '1' // even
		ddlb_range.SelectItem(2) 
		is_page_range = 'e'
	case '2' //odd
		ddlb_range.SelectItem(3) 
		is_page_range = 'o'
end choose


//if cbx_collate.checked then // collate output

ls_rc = idw_dw.describe('datawindow.print.collate')

If ls_rc = "yes" Then
	cbx_collate.checked = True
ElseIf ls_rc = "no" Then
	cbx_collate.checked = False
End If


//page_range 
ls_rc = idw_dw.describe('datawindow.print.page.range')
If ls_rc = "" Then
	is_page_range = "a"
	rb_all.checked = true
Else
	is_page_range = "p"
	rb_pages.checked =true
	sle_page_range.text = ls_rc
End If

//// number of copies ?
ls_rc = idw_dw.describe('datawindow.print.copies')

//copies = 0 is actually 1 copy.....

If ls_rc = "0" Then ls_rc = "1"
em_copies.text = ls_rc

//print to file ?
ls_rc = idw_dw.describe('datawindow.print.filename')
If ls_rc <> "" and ls_rc <>"!"Then 
	cbx_print_to_file.checked = True
	wf_enable_printfile()
	//strip the ~'s out of the file name to display properly
	ls_rc = f_global_replace(ls_rc,"~~","")
	st_print_file.text = ls_rc
Else
	cbx_print_to_file.checked = False
	wf_disable_printfile()
End If


end event
on w_dw_print_options.create
this.cbx_draft=create cbx_draft
this.cb_file=create cb_file
this.cb_printer=create cb_printer
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.st_print_file=create st_print_file
this.st_pf=create st_pf
this.ddlb_range=create ddlb_range
this.st_4=create st_4
this.cbx_collate=create cbx_collate
this.cbx_print_to_file=create cbx_print_to_file
this.st_3=create st_3
this.sle_page_range=create sle_page_range
this.rb_pages=create rb_pages
this.rb_current_page=create rb_current_page
this.rb_all=create rb_all
this.em_copies=create em_copies
this.st_2=create st_2
this.sle_printer=create sle_printer
this.st_1=create st_1
this.gb_1=create gb_1
this.Control[]={this.cbx_draft,&
this.cb_file,&
this.cb_printer,&
this.cb_cancel,&
this.cb_ok,&
this.st_print_file,&
this.st_pf,&
this.ddlb_range,&
this.st_4,&
this.cbx_collate,&
this.cbx_print_to_file,&
this.st_3,&
this.sle_page_range,&
this.rb_pages,&
this.rb_current_page,&
this.rb_all,&
this.em_copies,&
this.st_2,&
this.sle_printer,&
this.st_1,&
this.gb_1}
end on

on w_dw_print_options.destroy
destroy(this.cbx_draft)
destroy(this.cb_file)
destroy(this.cb_printer)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.st_print_file)
destroy(this.st_pf)
destroy(this.ddlb_range)
destroy(this.st_4)
destroy(this.cbx_collate)
destroy(this.cbx_print_to_file)
destroy(this.st_3)
destroy(this.sle_page_range)
destroy(this.rb_pages)
destroy(this.rb_current_page)
destroy(this.rb_all)
destroy(this.em_copies)
destroy(this.st_2)
destroy(this.sle_printer)
destroy(this.st_1)
destroy(this.gb_1)
end on

type cbx_draft from checkbox within w_dw_print_options
integer x = 1394
integer y = 660
integer width = 539
integer height = 72
integer textsize = -9
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Draft Quality"
borderstyle borderstyle = stylelowered!
end type

type cb_file from picturebutton within w_dw_print_options
integer x = 1445
integer y = 944
integer width = 302
integer height = 100
integer taborder = 50
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Narrow"
string text = "&File..."
vtextalign vtextalign = vcenter!
end type

event clicked;string ls_temp 
string ls_file
int li_rc
li_rc = GetFileSaveName("Print To File", ls_file, ls_temp, "PRN", "Print (*.PRN),*.PRN")

If li_rc = 1 Then	st_print_file.text = ls_file
end event

type cb_printer from picturebutton within w_dw_print_options
integer x = 1554
integer y = 296
integer width = 302
integer height = 100
integer taborder = 120
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Narrow"
string text = "Prin&ter..."
vtextalign vtextalign = vcenter!
end type

event clicked;printsetup()
sle_printer.text = idw_dw.describe('datawindow.printer')
end event

type cb_cancel from picturebutton within w_dw_print_options
integer x = 1554
integer y = 188
integer width = 302
integer height = 100
integer taborder = 20
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Narrow"
string text = "&Cancel"
vtextalign vtextalign = vcenter!
end type

event clicked;closewithreturn(parent,-1)
end event

type cb_ok from picturebutton within w_dw_print_options
integer x = 1554
integer y = 80
integer width = 302
integer height = 100
integer taborder = 110
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Narrow"
string text = "&Ok"
boolean default = true
vtextalign vtextalign = vcenter!
end type

event clicked;string tmp, command
long row 
string	docname, named
int	value

gi_pages = Integer(em_copies.text)
choose case lower(left(ddlb_range.text,1)) // determine rangeinclude (all,even,odd)
	case 'a' // all
		tmp = '0'
	case 'e' // even
		tmp = '1'
	case 'o' //odd
		tmp = '2'
end choose
command = 'datawindow.print.page.rangeinclude = '+tmp

if cbx_collate.checked then // collate output ?
	command = command +  " datawindow.print.collate = yes"
else
	command = command +  " datawindow.print.collate = no"
end if
if cbx_draft.checked  then // print in draft quality ?
	command = command +  " DataWindow.Print.Quality = 4"
end if

choose case is_page_range // did they pick a page range?
	case 'a'  // all
		tmp = ''
	case 'c' // current page?
		row = idw_dw.getrow()
		tmp = idw_dw.describe("evaluate('page()',"+string(row)+")")
	case 'p' // a range?
		tmp = sle_page_range.text
end choose		

command = command +  " datawindow.print.page.range = '"+tmp+"'"

// number of copies ?
if len(em_copies.text) > 0 then command = command +  " datawindow.print.copies = "+em_copies.text

If cbx_print_to_file.checked  and st_print_file.text = "" Then // print to file and no file seleted yet?
	value = GetFileSaveName("Print To File", docname, named, "PRN", "Print (*.PRN),*.PRN")
	if value = 1 then 
		st_print_file.text= docname
	else // they canceled out of the dialog so quit completely
		return
	end if
end if

If cbx_print_to_file.checked Then
	command = command + " datawindow.print.filename = '"+st_print_file.text+"'"
Else
	command = command + " datawindow.print.filename = '' "
End If

// now alter the datawindow
tmp = idw_dw.modify(command)
if len(tmp) > 0 then // if error the display the 
	messagebox('Error Setting Print Options','Error message = ' + tmp + '~r~nCommand = ' + command)
	return
end if
closewithreturn(parent,1)

end event

type st_print_file from statictext within w_dw_print_options
integer x = 297
integer y = 948
integer width = 1074
integer height = 96
integer textsize = -9
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
boolean border = true
boolean focusrectangle = false
end type

type st_pf from statictext within w_dw_print_options
integer x = 27
integer y = 948
integer width = 251
integer height = 72
integer textsize = -9
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
string text = "Print File:"
alignment alignment = right!
boolean focusrectangle = false
end type

type ddlb_range from dropdownlistbox within w_dw_print_options
integer x = 297
integer y = 808
integer width = 1070
integer height = 288
integer taborder = 130
integer textsize = -9
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "All Pages In Range"
boolean sorted = false
string item[] = {"All Pages in Range","Even Numbered Pages","Odd Numbered Pages"}
borderstyle borderstyle = stylelowered!
end type

type st_4 from statictext within w_dw_print_options
integer x = 101
integer y = 816
integer width = 178
integer height = 72
integer textsize = -9
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
string text = "P&rint:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cbx_collate from checkbox within w_dw_print_options
integer x = 1394
integer y = 576
integer width = 539
integer height = 72
integer taborder = 100
integer textsize = -9
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Collate Cop&ies"
borderstyle borderstyle = stylelowered!
end type

type cbx_print_to_file from checkbox within w_dw_print_options
integer x = 1394
integer y = 488
integer width = 439
integer height = 72
integer taborder = 90
integer textsize = -9
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Print to Fi&le"
borderstyle borderstyle = stylelowered!
end type

on clicked;If this.checked Then
	wf_enable_printfile()
Else
	wf_disable_printfile()
End If
end on

type st_3 from statictext within w_dw_print_options
integer x = 110
integer y = 640
integer width = 1189
integer height = 128
integer textsize = -9
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
string text = "Enter page numbers and/or page ranges separated by commas. For example, 2,5,8-10"
boolean focusrectangle = false
end type

type sle_page_range from singlelineedit within w_dw_print_options
integer x = 448
integer y = 512
integer width = 887
integer height = 88
integer taborder = 80
integer textsize = -9
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

event modified;rb_pages.triggerevent(clicked!)
end event

type rb_pages from radiobutton within w_dw_print_options
integer x = 146
integer y = 516
integer width = 302
integer height = 72
integer taborder = 70
integer textsize = -9
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Pa&ges:"
borderstyle borderstyle = stylelowered!
end type

on clicked;wf_page_range(this)
end on

type rb_current_page from radiobutton within w_dw_print_options
integer x = 146
integer y = 432
integer width = 466
integer height = 72
integer taborder = 60
integer textsize = -9
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Curr&ent Page"
borderstyle borderstyle = stylelowered!
end type

on clicked;wf_page_range(this)
end on

type rb_all from radiobutton within w_dw_print_options
integer x = 146
integer y = 340
integer width = 247
integer height = 72
integer taborder = 40
integer textsize = -9
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "&All"
borderstyle borderstyle = stylelowered!
end type

event clicked;wf_page_range(this)
end event

type em_copies from editmask within w_dw_print_options
integer x = 311
integer y = 144
integer width = 247
integer height = 96
integer taborder = 10
integer textsize = -9
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "1"
borderstyle borderstyle = stylelowered!
string mask = "#####"
end type

type st_2 from statictext within w_dw_print_options
integer x = 69
integer y = 164
integer width = 215
integer height = 72
integer textsize = -9
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
string text = "Copies:"
boolean focusrectangle = false
end type

type sle_printer from singlelineedit within w_dw_print_options
integer x = 311
integer y = 52
integer width = 869
integer height = 84
integer textsize = -9
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
boolean border = false
boolean autohscroll = false
end type

type st_1 from statictext within w_dw_print_options
integer x = 69
integer y = 56
integer width = 215
integer height = 72
integer textsize = -9
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
string text = "Printer:"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_dw_print_options
integer x = 69
integer y = 272
integer width = 1303
integer height = 524
integer taborder = 30
integer textsize = -9
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Page Range"
borderstyle borderstyle = stylelowered!
end type

