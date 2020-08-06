#=============================================
# ${MY_ROOT_BIN_DIR} is required global
# ${MY_ROOT_ENVVARS_DIR} is required global
# ${MY_ROOT_ALIASES_DIR} is required global
# ${MY_ROOT_AUTOCOMPLETE_DIR} is required global
# ${MY_ROOT_TEMPLATES_DIR} is required global
# $1 (first parameter) is required
#=============================================


$PROJECT_NAME = $args[0]

# check for valid input
if ([string]::IsNullOrEmpty($PROJECT_NAME)) {
	Write-Output "Need a project name for input"
	exit 1
}


$PROJECT_NAME_UPPERCASE = $PROJECT_NAME.toUpper()
$PROJECT_NAME_LOWERCASE =  $PROJECT_NAME.toLower()

Write-Output $PROJECT_NAME_UPPERCASE
Write-Output $PROJECT_NAME_LOWERCASE

#=============================================
# CREATE DIRECTORIES
#=============================================

# create string variable working dir
$PROJECT_DIR = (Get-Location).Path

# create string variable for bash dir
# BASH_DIR="${PROJECT_DIR}/${PROJECT_NAME_LOWERCASE}-bash-scripts"
$SCRIPTS_DIR = "${PROJECT_DIR}/${PROJECT_NAME_LOWERCASE}-powershell-scripts"
# create string variable for bin dir
$BIN_DIR = "$SCRIPTS_DIR/bin"
# create string variable for aliases dir
$ALIASES_DIR = "$SCRIPTS_DIR/aliases"
# create string variable for envvars dir
$ENVVARS_DIR = "$SCRIPTS_DIR/envvars"
# create string variable for autocomplete dir
$AUTOCOMPLETE_DIR = "$SCRIPTS_DIR/autocomplete"


# Write-Output "creating powershell scripts dir"
# mkdir -p "${SCRIPTS_DIR}"
# Write-Output "created powershell scripts dir at ${SCRIPTS_DIR}"

# Write-Output "creating bin dir"
# mkdir -p "${BIN_DIR}"
# Write-Output "created bin dir at ${BIN_DIR}"

# Write-Output "creating aliases dir"
# mkdir -p "${ALIASES_DIR}"
# Write-Output "created aliases dir at ${ALIASES_DIR}"

# Write-Output "creating envvars dir"
# mkdir -p "${ENVVARS_DIR}"
# Write-Output "created envvars dir at ${ENVVARS_DIR}"

# Write-Output "creating autocomplete dir"
# mkdir -p "${AUTOCOMPLETE_DIR}"
# Write-Output "created autocomplete dir at ${AUTOCOMPLETE_DIR}"

#=============================================
# FUNCTIONS TO CREATE FILES
#=============================================

# get_rendered_template_file_content() {
# 	TEMPLATE_FILE_ABSOLUTE_PATH="${1}"
# 	echo "$(cat "${TEMPLATE_FILE_ABSOLUTE_PATH}" \
# 	    | sed 's#%PROJECT_NAME_UPPERCASE%#'${PROJECT_NAME_UPPERCASE}'#g' \
# 	    | sed 's#%PROJECT_NAME_LOWERCASE%#'${PROJECT_NAME_LOWERCASE}'#g' \
# 	    | sed 's#%PROJECT_DIR%#'${PROJECT_DIR}'#g' \
# 	)"
# }
function GET_RENDERED_TEMPLATE_FILE_CONTENT {
	$TEMPLATE_FILE_ABSOLUTE_PATH = $args[0]

	Write-Output "Template File Absolute Path ${TEMPLATE_FILE_ABSOLUTE_PATH}"
	
	$CONTENT = (Get-Content -path $TEMPLATE_FILE_ABSOLUTE_PATH -Raw) -replace '%PROJECT_NAME_UPPERCASE%',$PROJECT_NAME_UPPERCASE -replace '%PROJECT_NAME_LOWERCASE%',$PROJECT_NAME_LOWERCASE -replace '%PROJECT_DIR%',$PROJECT_DIR

	Write-Output "$CONTENT"		
}


# create_file() {
# 	FILE_NAME="${1}"
# 	LOCAL_DIR="${2}"
# 	TEMPLATE_FILE_ABSOLUTE_PATH="${3}"
# 	FILE_LOCAL_PATH="${LOCAL_DIR}/${FILE_NAME}"

# 	touch "${FILE_LOCAL_PATH}"
# 	echo "$(get_rendered_template_file_content "${TEMPLATE_FILE_ABSOLUTE_PATH}")" \
# 		>> "${FILE_LOCAL_PATH}"
# 	echo '' >> "${FILE_LOCAL_PATH}"
# }
function CREATE_FILE {
	$FILE_NAME = $args[0]
	$LOCAL_DIR = $args[1]
	$TEMPLATE_FILE_ABSOLUTE_PATH = $args[2]
	$FILE_LOCAL_PATH="${LOCAL_DIR}/${FILE_NAME}"
	$CONTENT = (. GET_RENDERED_TEMPLATE_FILE_CONTENT "$TEMPLATE_FILE_ABSOLUTE_PATH") 
	
	Write-Output "$CONTENT"  # >> "${FILE_LOCAL_PATH}"
}


# make_file_executable() {
# 	FILE_NAME="${1}"
# 	LOCAL_DIR="${2}"
# 	FILE_LOCAL_PATH="${LOCAL_DIR}/${FILE_NAME}"

# 	chmod +x "${FILE_LOCAL_PATH}"
# }

# link_file() {
# 	FILE_NAME="${1}"
# 	LOCAL_DIR="${2}"
# 	GLOBAL_DIR="${3}"

# 	FILE_LOCAL_PATH="${LOCAL_DIR}/${FILE_NAME}"
# 	FILE_GLOBAL_PATH="${GLOBAL_DIR}/${FILE_NAME}"

# 	ln "${FILE_LOCAL_PATH}" "${FILE_GLOBAL_PATH}"
# }
function LINK_FILE {
	$FILE_NAME = $args[0]
	$LOCAL_DIR = $args[1]
	$GLOBAL_DIR = $args[2]

	$FILE_LOCAL_PATH="${LOCAL_DIR}/${FILE_NAME}"
	$FILE_GLOBAL_PATH="${GLOBAL_DIR}/${FILE_NAME}"

	New-Item -ItemType HardLink -Name "$FILE_LOCAL_PATH" -Value "$FILE_GLOBAL_PATH"
}


# create_executable_and_linked_file() {
# 	FILE_NAME="${1}"
# 	LOCAL_DIR="${2}"
# 	GLOBAL_DIR="${3}"
#   TEMPLATE_FILE_ABSOLUTE_PATH="${4}"

# 	create_file "${FILE_NAME}" "${LOCAL_DIR}" "${TEMPLATE_FILE_ABSOLUTE_PATH}"
# 	make_file_executable "${FILE_NAME}" "${LOCAL_DIR}"
# 	link_file \
# 		"${FILE_NAME}" "${LOCAL_DIR}" "${GLOBAL_DIR}"
# }
function CREATE_EXECUTABLE_AND_LINKED_FILE {
	$FILE_NAME = $args[0]
	$LOCAL_DIR = $args[1]
	$GLOBAL_DIR = $args[2]
	$TEMPLATE_FILE_ABSOLUTE_PATH = $args[3]

	CREATE_FILE "${FILE_NAME}" "${LOCAL_DIR}" "${TEMPLATE_FILE_ABSOLUTE_PATH}"
	LINK_FILE "${FILE_NAME}" "${LOCAL_DIR}" "${GLOBAL_DIR}"
}

#=============================================
# CREATE ALIAS FILE
#=============================================
$ALIAS_FILE="${PROJECT_NAME_LOWERCASE}.aliases.ps1"
$ALIAS_TEMPLATE_ABSOLUTE_PATH="$env:MY_ROOT_TEMPLATES_DIR/aliases.ps1.template"


Write-Output (GET_RENDERED_TEMPLATE_FILE_CONTENT $env:MY_ROOT_TEMPLATES_DIR/aliases.ps1.template)

# . CREATE_EXECUTABLE_AND_LINKED_FILE 
# 	"${ALIAS_FILE}" 
# 	"${ALIASES_DIR}" 
# 	"$env:MY_ROOT_ALIASES_DIR" 
# 	"${ALIAS_TEMPLATE_ABSOLUTE_PATH}"

#=============================================
# CREATE ALIAS SITES FILE
#=============================================

# ALIAS_SITE_FILE="${PROJECT_NAME_LOWERCASE}.aliases.sites"
# ALIAS_SITES_TEMPLATE_ABSOLUTE_PATH="${MY_ROOT_TEMPLATES_DIR}/aliases.sites.template"

# create_executable_and_linked_file \
# 	"${ALIAS_SITE_FILE}" \
# 	"${ALIASES_DIR}" \
# 	"${MY_ROOT_ALIASES_DIR}" \
# 	"${ALIAS_SITES_TEMPLATE_ABSOLUTE_PATH}"


#=============================================
# CREATE AUTOCOMPLETE FILE
#=============================================
# AUTOCOMPLETE_FILE="${PROJECT_NAME_LOWERCASE}.autocomplete"
# AUTOCOMPLETE_TEMPLATE_ABSOLUTE_PATH="${MY_ROOT_TEMPLATES_DIR}/autocomplete.template"

# create_executable_and_linked_file \
# 	"${AUTOCOMPLETE_FILE}" \
# 	"${AUTOCOMPLETE_DIR}" \
# 	"${MY_ROOT_AUTOCOMPLETE_DIR}" \
# 	"${AUTOCOMPLETE_TEMPLATE_ABSOLUTE_PATH}"

#=============================================
# CREATE {project}.create.command FILE
#=============================================
# PROJECT_CREATE_COMMAND_FILE_NAME="${PROJECT_NAME_LOWERCASE}.create.command"
# PROJECT_CREATE_COMMAND_TEMPLATE_ABSOLUTE_PATH="${MY_ROOT_TEMPLATES_DIR}/create.command.template"

# create_executable_and_linked_file \
# 	"${PROJECT_CREATE_COMMAND_FILE_NAME}" \
# 	"${BIN_DIR}" \
# 	"${MY_ROOT_BIN_DIR}" \
# 	"${PROJECT_CREATE_COMMAND_TEMPLATE_ABSOLUTE_PATH}"

#=============================================
# CREATE ENVVARS FILE
#=============================================

# ENVVARS_FILE_NAME="${PROJECT_NAME_LOWERCASE}.envvars"
# ENVVARS_TEMPLATE_ABSOLUTE_PATH="${MY_ROOT_TEMPLATES_DIR}/envvars.template"

# create_executable_and_linked_file \
# 	"${ENVVARS_FILE_NAME}" \
# 	"${ENVVARS_DIR}" \
# 	"${MY_ROOT_ENVVARS_DIR}" \
# 	"${ENVVARS_TEMPLATE_ABSOLUTE_PATH}"
