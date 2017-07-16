public class AdhocScheduler {
    public List<SelectOption> objNames{get;set;}
    public List<SelectOption> objFields{get;set;}
    public Boolean showFields{get;set;}
    public String selectedObj{get;set;}
    public String selectedField{get;set;}
    public List<filterWrapper> filterWrapperList {get;set;}
    public String filterLogic{get;set;}
    public Boolean applyFilters{get;set;}
    public Boolean applyFilterLogic{get;set;}
    public Integer sequence{get;set;}
    public Integer removeId { get; set; }
    private List<Integer> filterLogicList = new List<Integer>();
    private Set<Integer> filterLogicSet = new Set<Integer>();
    private Map<String, Schema.SObjectField> fieldMap;
    public String preUsedFilter {get;set;}
    public Scheduler__c sch{get;set;}
    public List<SelectOption> actions{get;set;}
    public String selectedAction{get;set;}
    private String nullAllowedDataTypes = 'Datetime,Date,Decimal,Integer,String';
    
    public Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe(); 
    public AdhocScheduler(){
        getSobjectNames();
        showFields = false;
        filterWrapperList = new List<filterWrapper>();
        applyFilterLogic = false;
        assignActions();
    }

    public void assignActions(){
        actions = new List<SelectOption>();
        actions.add(new SelectOption('','--None--'));
        actions.add(new SelectOption('Schedule','Schedule'));
        actions.add(new SelectOption('Create','Create Related Records'));
        actions.add(new SelectOption('Update','Update Related Records'));
        actions.add(new SelectOption('Email','Email Alert'));
    }

    public void save(){
        if(validateFilterScreen()){

        }
    }
    
    public void getSobjectNames(){
        objNames = new List<SelectOption>();
        objNames.add(new SelectOption('','--None--'));
        for(Schema.SObjectType o : schemaMap.values()){
            Schema.DescribeSObjectResult objResult = o.getDescribe();
            system.debug( 'Sobject: ' + objResult );
            system.debug( 'Sobject API Name: ' + objResult.getName() );
            system.debug( 'Sobject Label Name: ' + objResult.getLabel() ); 
            objNames.add(new SelectOption(objResult.getName(),objResult.getLabel()));
        }
    }
    
    public void getObjFields(){
        objFields = new List<SelectOption>();
        if(String.isBlank(selectedObj)){
            showFields = false;
            return;
        }
        showFields = true;
        objFields.add(new SelectOption('','--None--'));
        Schema.SObjectType objSchema = schemaMap.get(selectedObj);
        fieldMap = objSchema.getDescribe().fields.getMap();
        for(Schema.SObjectField s1:fieldMap.values()){ 
            objFields.add(new SelectOption(String.valueOf(s1),String.valueOf(s1.getDescribe().getName())));
            //system.debug(s1.getDescribe().getName());
            //system.debug(M.get(s1.getDescribe().getName()).getDescribe());
        }
        activateFilters();
    }
    
    //To validate Filter screen
    private Boolean validateFilterScreen(){
        //system.debug('actSch=='+actSch);
        //if(actSch != NULL) validations();
        if(applyFilters){
            /*if(filterWrapperList.isEmpty() && preUsedFilter == NULL && selectedFilter == 'Predefined Filter'){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Please select predefined filter'));
                return false;
            }*/
            //system.debug('filterWrapperList12=='+filterWrapperList);
            for(filterWrapper fw: filterWrapperList){
                if(fw.dataType == 'Date' && fw.sch.Schedule_Date__c != NULL){
                    fw.datetimeValue = fw.sch.Schedule_Date__c;
                    fw.value = fw.datetimeValue.format('yyyy-MM-dd');
                }
                
                if(fw.dataType == 'Datetime' && fw.sch.Schedule_Datetime__c != NULL){
                    fw.value = fw.sch.Schedule_Datetime__c.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
                }
                
                /*if(fw.dataType == 'Lookup'){
                    String query = 'Select Id from '+createWorkItemsMap.get(fw.filterOption).Object__c+' where Name = \''+fw.lookupValue+'\'';
                    //system.debug('query=='+query);
                    try{
                        List<SObject> obj = Database.query(query);
                        if(!obj.isEmpty()){
                            fw.value = (String)obj[0].get('Id');
                        } else {
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'No data found for '+createWorkItemsMap.get(fw.filterOption).Name+' with the given value '+fw.lookupValue));
                            return false;
                        }
                    } catch (exception e){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Error in the lookup value: '+e.getMessage()));
                        return false;
                    }
                }*/
                
                //system.debug('createWorkItemsMap==='+fw.dataType+'=='+nullAllowedDataTypes.containsIgnoreCase(fw.dataType)+'=='+fw.value+'=='+fw.filterOperator);
				if(!String.isEmpty(fw.dataType) && nullAllowedDataTypes.containsIgnoreCase(fw.dataType) && !String.isEmpty(fw.value) && fw.filterOperator.containsIgnoreCase('null')){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'You cannot provide value if the filter operator equals \'is null\' or \'is not null\''));
                    return false;
				}

				if(String.isEmpty(fw.filterOption) || String.isEmpty(fw.filterOperator)){
					ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Please provide Filter, Operator and Value'));
					return false;
				}
				
				if(String.isEmpty(fw.value) && !fw.filterOperator.containsIgnoreCase('null')){
					//system.debug('fw.filterOption=='+fw.filterOption+'=='+fw.value+'=='+fw.sequence);
					//Provide error message on Page if the values are NULL
					ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Please provide Filter, Operator and Value'));
					return false;
				}

                String fieldDataType = String.valueOf(fieldMap.get(fw.filterOption).getDescribe().getType());
                String fieldName = String.valueOf(fieldMap.get(fw.filterOption).getDescribe().getName());

                //Custom Setting value with data type Decimal must be validated against the Value provided on VF page
                if(fieldDataType.equalsIgnoreCase('Decimal') && !fw.filterOperator.containsIgnoreCase('null')){
                    //Provide error message on Page if the value is not Decimal
                    try{
                        //Verify the value provided is Decimal
                        Decimal dec = Decimal.valueOf(fw.value);
                    }catch(exception e){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Please provide only Decimal value for '+fieldName));
                        return false;
                    }
                }
                //Custom Setting value with data type Integer must be validated against the Value provided on VF page
                if(fieldDataType.equalsIgnoreCase('Integer') && !fw.filterOperator.containsIgnoreCase('null')){
                    //Provide error message on Page if the value is not Integer
                    try{
                        //Verify the value provided is Integer
                        Integer Intg = Integer.valueOf(fw.value);
                    }catch(exception e){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Please provide only Integer value for '+fieldName));
                        return false;
                    }
                }
            }
        }
        return true;
    }

	String parseFilterLogic(String filterLogic){
        if(filterLogic.containsAny('()')){
            filterLogic = filterLogic.replace('(','( ');
            filterLogic = filterLogic.replace(')',' )');
        }
		String hiddenFilterLogic;
		for(String st: filterLogic.split(' ')){
			try {	        
				Integer i = Integer.valueOf(st);
				if (hiddenFilterLogic!=null){
					hiddenFilterLogic += ' x'+i+'x';
				}else{
					hiddenFilterLogic = 'x'+i+'x';
				}
			}catch (exception e){
				if (hiddenFilterLogic!=null){
					hiddenFilterLogic += ' '+st;
				}else{
					hiddenFilterLogic = st;
				}
			}
		}
		return hiddenFilterLogic;
	}

	//This method works based on the filteroption selected
	//Custom Filter - provides option to add new filters using filters picklist
	//Predefined Filter - These are saved filters on Activity Schedule fiter object, The user can select the relevant filter instead of creating a new one
	//No Filter - This is used to create work items for all the Responses of the collection instance
    public void activateFilters(){
        resetVariables();
        /*if(action == NULL){
            actSch.Filter_Name__c = NULL;
            actSch.Filter_Description__c = NULL;
        }*/
        applyFilters = true;
        //filterNameReadOnly = false;
        addFilter();
        /*if(selectedFilter == 'Custom Filter'){
            resetVariables();
            if(action == NULL){
                actSch.Filter_Name__c = NULL;
                actSch.Filter_Description__c = NULL;
            }
            applyFilters = true;
            filterNameReadOnly = false;
            addFilter();
        } else if(selectedFilter == 'Predefined Filter'){
            resetVariables();
            actSch.Filter_Name__c = null;
            actSch.Filter_Description__c = null;
            predefinedFilterCriteria();
            applyFilters = true;   
        } else if(selectedFilter == 'No Filter'){
            resetVariables();
            actSch.Filter_Name__c = null;
            actSch.Filter_Description__c = null;
            applyFilters = false;
        }*/ 
    }

    private void resetVariables(){
        preUsedFilter = null;
        filterWrapperList = new List<filterWrapper>();
        filterLogic = null;
    }

    //Add function to generate more rows on Filter Screen
    public void addFilter(){
        if(validateFilterScreen()){
            //system.debug('filterLogic=='+filterLogic);
            for(filterWrapper fw: filterWrapperList){
                fw.andOperator = 'AND';
            }
            
            filterWrapper fw = new filterWrapper();
            fw.uniqueId = filterWrapperList.size();
            fw.sequence = filterWrapperList.size()+1;
            fw.dataType = null;
            //fw.ci = new Collection_Instance__c();
            filterWrapperList.add(fw);

			//Filter logic sequence is automatically formed if the user doesn't click on 'Add Filter Logic' link
            if(!applyFilterLogic){
                filterLogicSet.add(fw.sequence);
                filterLogicList.clear();
                filterLogicList.addAll(filterLogicSet);
                filterLogic = String.join(filterLogicList,' AND ');
                system.debug('filterLogicSet=='+filterLogicSet+'=='+filterLogicList+'=='+filterLogic);
            }
        }
    }
    
    public static list<SelectOption> getPicklistValues(String ObjectApi_name, String fld,Boolean noneRequired){
        list<SelectOption> options = new list<SelectOption>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(ObjectApi_name);
        Sobject Object_name = targetType.newSObject();
        // Get the object type of the SObject.
        Schema.sObjectType objType = Object_name.getSObjectType();
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        // Get a map of fields for the SObject
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        // Get the list of picklist values for this field.
        list<Schema.PicklistEntry> values = fieldMap.get(fld).getDescribe().getPickListValues();
        if(noneRequired){
            options.add(new SelectOption('', '--None--'));
        }
        // Add these values to the selectoption list.
        for (Schema.PicklistEntry a : values){
            options.add(new SelectOption(a.getLabel(), a.getValue()));
        }
        return options;
    }
    
    //Method to set the Value field based on the Option Selected
    public void changeValueDataType(){
        String fOption = filterWrapperList[sequence-1].filterOption;
		resetFilterVariables();
		if(String.isBlank(fOption)){return;}

        //filterWrapperList[sequence-1].filterOperator = NULL;
        filterWrapperList[sequence-1].operators = new List<SelectOption>();
        filterWrapperList[sequence-1].operators.add(new SelectOption('','--None--'));
        filterWrapperList[sequence-1].operators.add(new SelectOption('=','equals'));
        filterWrapperList[sequence-1].operators.add(new SelectOption('!=','not equal to'));
		/*if(fOption.containsIgnoreCase('GR_')){
			List<SelectOption> filterOpertors = assignFilterOperators('String');
			filterWrapperList[sequence-1].dataType = 'String';
			//Forming the grouping value API from grouping label. Eg: GR_1_Label__c to GV1__c
			String groupingValApi = 'GV'+fOption.split('_')[1]+'__c'; 
			String gropuingVal = (String)grp.get(groupingValApi);
			if(String.isNotBlank(gropuingVal)){
				filterWrapperList[sequence-1].dataType = 'Picklist';
				filterWrapperList[sequence-1].picklistOptions = fetchGroupingPicklistValues(gropuingVal);
			}
			//System.debug('sequence=='+(sequence-1));
			groupingFilterRowId.add(sequence-1);
			return;
		}*/
        //system.debug('createWorkItemsMap=='+createWorkItemsMap+'=='+fOption+'=='+groupingFilterRowId);
        String fieldDataType = String.valueOf(fieldMap.get(fOption).getDescribe().getType());
        List<SelectOption> filterOpertors = assignFilterOperators(fieldDataType);
        if(filterOpertors.size()>0){
            filterWrapperList[sequence-1].operators.addAll(filterOpertors);
        }
        system.debug('fieldDataType=='+fieldDataType);
        if(fieldDataType.equalsignorecase('String') || fieldDataType.equalsignorecase('Textarea')){
            filterWrapperList[sequence-1].dataType = 'String';
        } else if(fieldDataType.equalsignorecase('Decimal') || fieldDataType.equalsignorecase('Integer')){
            filterWrapperList[sequence-1].dataType = 'String';
        } else if(fieldDataType.equalsignorecase('Lookup')){
            filterWrapperList[sequence-1].dataType = 'Lookup';
            filterWrapperList[sequence-1].operators.remove(2); //remove not equal to
        } else if(fieldDataType.equalsignorecase('Boolean')){
            filterWrapperList[sequence-1].dataType = 'Boolean';
        } else if(fieldDataType.equalsignorecase('Date')){
            filterWrapperList[sequence-1].dataType = 'Date';
        } else if(fieldDataType.equalsignorecase('Datetime')){
            filterWrapperList[sequence-1].dataType = 'Datetime';
        } else if(fieldDataType.equalsignorecase('Picklist')){
            filterWrapperList[sequence-1].dataType = 'Picklist';
            String apiName;
            
            //Check if the API Name contains references to other object fields like Unit_of_Interest__r.Address_Type__c
            //Fetch only field API Name from the string
            //Assign to fOption directly if '.' is not found
            if(fOption.contains('.')){
                List<String> apiList = fOption.split('\\.');
                apiName = apiList[apiList.size()-1];
            } else {
                apiName = fOption;
            }
            
            //Fetch the picklist values for the field based on the Object and API Name of the field
            filterWrapperList[sequence-1].picklistOptions = getPicklistValues(selectedObj,apiName,true);
        }else{
            filterWrapperList[sequence-1].dataType = NULL;
        }
        
        filterWrapperList[sequence-1].value = null;
		//System.debug('filterWrapperList345=='+filterWrapperList);
    }

	//Reset filter variables
	private void resetFilterVariables(){
		filterWrapperList[sequence-1].operators = new List<SelectOption>();			
		filterWrapperList[sequence-1].dataType = null;
		filterWrapperList[sequence-1].picklistOptions = new List<SelectOption>();
		filterWrapperList[sequence-1].value = null;
		filterWrapperList[sequence-1].dateValue = null;
		filterWrapperList[sequence-1].datetimeValue = null;
		//filterWrapperList[sequence-1].ci = new Collection_Instance__c();
	}
    
	//Assign filter operators based on datatype
    public List<SelectOption> assignFilterOperators(String dataType){
        List<SelectOption> operatorList = new List<SelectOption>();
        if(dataType.equalsignorecase('Datetime') || dataType.equalsignorecase('Date') || dataType.equalsignorecase('Decimal') || dataType.equalsignorecase('Integer')){
            operatorList.add(new SelectOption('>','greater than'));
            operatorList.add(new SelectOption('<','less than'));
            operatorList.add(new SelectOption('>=','greater or equal'));
            operatorList.add(new SelectOption('<=','less or equal'));
			operatorList.add(new SelectOption('= null','is null'));
			operatorList.add(new SelectOption('!= null','is not null'));
        } else if(dataType.equalsignorecase('String')){
            operatorList.add(new SelectOption('like','contains'));
            operatorList.add(new SelectOption('not like','does not contain'));
            operatorList.add(new SelectOption('starts','starts with'));
			operatorList.add(new SelectOption('= null','is null'));
			operatorList.add(new SelectOption('!= null','is not null'));
        }
        
        return operatorList;
    }
    
    //Remove function to remove rows from Filter Screen
    public void removeSelected(){
        filterWrapperList.remove(removeId);
		restructureFilterWrapperList();
    }

	void restructureFilterWrapperList(){
        filterLogicList.clear();
        filterLogicSet.clear();
        for(integer i=0; i<filterWrapperList.size(); i++){
            filterWrapperList[i].uniqueId = i;
            filterWrapperList[i].sequence = i+1;
            if(filterWrapperList.size()-1 == i){
                filterWrapperList[i].andOperator = Null;
            }
            filterLogicSet.add(filterWrapperList[i].sequence);
        }

        //Form the filter logic 
        if(!applyFilterLogic){
            filterLogicList.addAll(filterLogicSet);
            filterLogic = String.join(filterLogicList,' AND '); 
        }
	}

    //Add filter logic
    public void applyFilterLogicMethod(){
        applyFilterLogic = true;
    }

    //Clear filter logic
    public void clearFilterLogicMethod(){
        applyFilterLogic = false;
        filterLogicList.clear();
        filterLogicSet.clear();
        
        for(integer i=0; i<filterWrapperList.size(); i++){
            filterLogicSet.add(filterWrapperList[i].sequence);
        }
        filterLogicList.addAll(filterLogicSet);
        filterLogic = String.join(filterLogicList,' AND ');
    }

    //Wrapper for Filter Screen
    public class filterWrapper{
        public String filterOption{get;set;}
        public String filterOperator{get;set;}
        public List<SelectOption> operators{get;set;}
        public String value{get;set;}
        public String lookupValue{get;set;}
        public Scheduler__c sch{get;set;}
        public Date dateValue{get;set;}
        public Datetime datetimeValue{get;set;}
        public String dataType{get;set;}
        public list<SelectOption> picklistOptions{get;set;}
        public Integer uniqueId{get;set;}
        public String andOperator{get;set;}
        public Integer sequence{get;set;}
    }
}