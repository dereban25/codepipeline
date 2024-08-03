- Name: Build
  Actions:
      - Name: CodeBuild
        InputArtifacts:
          - Name: SourceApp
        ActionTypeId:
          Category: Build
          Owner: AWS
          Version: "1"
          Provider: CodeBuild
        OutputArtifacts:
          - Name: BuiltApp
        Configuration:
          ProjectName: !Ref CustomControlTowerCodeBuild
- !If
  - IsPipelineApprovalStageCondition
  - Name: Approval
    Actions:
      - Name: Approval
        ActionTypeId:
          Category: Approval
          Owner: AWS
          Version: "1"
          Provider: Manual
        RunOrder: 1
        Configuration:
          NotificationArn: !Ref PipelineApprovalTopic
  - !Ref AWS::NoValue