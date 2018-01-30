# ADCompliance
- [Description](#description)
- [Branching](#branching)
- [Commiting](#commiting)
- [Pull Requests and Merging](#pull-requests-and-merging)

## Description
ADCompliance is a collection of rules to generate compliance reports for Active Directory.

## Branching
| Name    | Branch Name                      | When?                                                                             | Source                                 |
|---------|----------------------------------|-----------------------------------------------------------------------------------|----------------------------------------|
| Feature | `feature/BCT-0000-featureName`   | Adding or changing functionality.                                                 | Branch off master into feature branch. |
| BugFix  | `bugfix/BCT-0000-bugDescription` | Changes required to get "By-Design" functinality for already integrated features. | Branch off master into bugfix branch.  |

## Commiting
All commits should have either a JIRA issue number or a brief (less then 50 characters) description on the first line of the commit message.

## Pull Requests and Merging
Once completed a pull request should be created to merge the feature with the master branch.
Pull requests don't need explicit revision by a different user but please doublecheck code before merging.