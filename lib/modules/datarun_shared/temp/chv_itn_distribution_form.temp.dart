final Map<String, dynamic> dTempItnDistributionForm = {
  "paging": true,
  "page": 0,
  "pageCount": 1,
  "total": 2,
  "pageSize": 20,
  "dynamicForms": [
    {
      "id": "3",
      "uid": "r1j366zL3VB",
      "name": "ITN Distribution",
      "code": "ITN_Distribution_FORM",
      "createdDate": "2024-06-13T00:00:00.000Z",
      "lastModifiedDate": "2024-06-13T00:00:00.000Z",
      "activity": {
        "id": 16,
        "uid": "oAne601mA8n",
      },
      "fields": [
        {
          "id": "1",
          "type": "date",
          "label": "Visit Date",
          "name": "visitDate",
          "options": null,
          "fieldRule": {
            "required": true,
            "minLength": null,
            "maxLength": null,
            "numeric": null,
            "email": null,
            "dependentFieldId": null,
            "dependentFieldValues": null
          }
        },
        {
          "id": "2",
          "type": "text",
          "label": "Patient Name",
          "name": "patientName",
          "options": null,
          "fieldRule": {
            "required": true,
            "minLength": null,
            "maxLength": null,
            "numeric": null,
            "email": null,
            "dependentFieldId": null,
            "dependentFieldValues": null
          }
        },
        {
          "id": "3",
          "type": "text",
          "label": "Patient Age",
          "name": "patientAge",
          "options": null,
          "fieldRule": {
            "required": true,
            "minLength": null,
            "maxLength": null,
            "numeric": null,
            "email": null,
            "dependentFieldId": null,
            "dependentFieldValues": null
          }
        },
        {
          "id": "4",
          "type": "text",
          "label": "Patient Location",
          "name": "patientLocation",
          "options": null,
          "fieldRule": {
            "required": true,
            "minLength": null,
            "maxLength": null,
            "numeric": null,
            "email": null,
            "dependentFieldId": null,
            "dependentFieldValues": null
          }
        },
        {
          "id": "5",
          "type": "selectOne",
          "name": "gender",
          "label": "Gender",
          "options": ["Male", "Female", "Other"],
          "rules": {"required": true}
        },
        {
          "id": "6",
          "type": "yesNo",
          "label": "Pregnant",
          "name": "pregnant",
          "options": null,
          "fieldRule": {
            "required": false,
            "minLength": null,
            "maxLength": null,
            "numeric": null,
            "email": null,
            "dependentFieldId": null,
            "dependentFieldValues": null
          }
        },
        {
          "id": "7",
          "type": "selectOne",
          "label": "Test Result",
          "name": "testResult",
          "options": ["NEGATIVE", "PF", "PV", "MIX", "INVALID"],
          "fieldRule": {
            "required": false,
            "minLength": null,
            "maxLength": null,
            "numeric": null,
            "email": null,
            "dependentFieldId": null,
            "dependentFieldValues": null
          }
        },
        {
          "id": "8",
          "type": "selectOne",
          "label": "Detection Type",
          "name": "detectionType",
          "options": ["REACTIVE", "ACTIVE"],
          "fieldRule": {
            "required": false,
            "minLength": null,
            "maxLength": null,
            "numeric": null,
            "email": null,
            "dependentFieldId": null,
            "dependentFieldValues": null
          }
        },
        {
          "id": "9",
          "type": "selectOne",
          "label": "Severity",
          "name": "severity",
          "options": ["SIMPLE", "SEVERE"],
          "fieldRule": {
            "required": false,
            "minLength": null,
            "maxLength": null,
            "numeric": null,
            "email": null,
            "dependentFieldId": null,
            "dependentFieldValues": null
          }
        },
        {
          "id": "10",
          "type": "selectOne",
          "label": "Treatment",
          "name": "treatment",
          "options": ["TREATED", "FIRSTDOSE", "REFERAL"],
          "fieldRule": {
            "required": false,
            "minLength": null,
            "maxLength": null,
            "numeric": null,
            "email": null,
            "dependentFieldId": null,
            "dependentFieldValues": null
          }
        },
        {
          "id": "11",
          "type": "text",
          "label": "Comment",
          "name": "comment",
          "options": null,
          "fieldRule": {
            "required": false,
            "minLength": null,
            "maxLength": 2000,
            "numeric": null,
            "email": null,
            "dependentFieldId": null,
            "dependentFieldValues": null
          }
        }
      ],
    }
  ]
};