## Checklist

<!--
All items should be checked when the PR is merged!
The testing and documentation lines can be deleted if a PR has not changed any
functionality, for example, with a documentation update.
-->
- [ ] I have reviewed the [Code of Conduct] and [CONTRIBUTING] guide
- [ ] I have tested my changes and provided evidence below
- [ ] I have updated documentation for new/changed functionality
- [ ] All active GitHub checks for tests, formatting, and security related to my changes are passing
- [ ] This PR _DOES_OR_DOES_NOT_ :rotating_light: contain breaking (not reverse compatible) changes <!-- Update this! -->

## What this PR does / why we need it

<!-- Delete unnecessary lines, and update relevant lines -->
This pull request:
- Resolves #1234 by _HOW_CHANGED_
OR
- Fixes _DESCRIBE_BUG_ by _HOW_CHANGED_
- Improves _FEATURE_NAME_ by _HOW_CHANGED_
- Adds _FEATURE_ which _DOES_WHAT_THING_
- Updates _DOCUMENTATION_FILE_ by _HOW_AND_OR_WHY_CHANGED_
- Resolves _TECH_DEBT_ITEM_ by _HOW_CHANGED_

### User facing changes

<details><summary><i>The following shows some of the user facing changes introduced in this PR</i></summary>

_**DESCRIPTION**_:
_SCREENSHOT1_

_**DESCRIPTION**_:
_SCREENSHOT2_

_**DESCRIPTION**_:
_VIDEO1_

_**DESCRIPTION**_:
_VIDEO2_
</details>

## Notes for the reviewer

<!--
Particularly if there is not a pre-existing Issue or Discussion to accompany
this PR, this is the place to add background information, including the
impacts of the proposed change. For the benefit of the community, please do not
assume prior context. Provide details that support your chosen implementation,
including alternatives considered.

Put None here if Nothing to add
-->
_WORDS_FROM_CONTRIBUTOR_FOR_REVIEWERS_

<!-- Delete links section if none -->
Relevant links:
- _LINK_TO_DISCUSSION_
- _LINK_TO_RESOURCES_THAT_GUIDED_YOU_

## Testing / How to verify it

<!-- Delete the following if N/A -->
> [!NOTE]
> _Tests for SPECIFIC_RELATED_CASE were excluded because VERY_GOOD_REASON_

<!--
Copy/Paste/Edit the following blocks as many times as needed. Don't forget
regression tests, particularly for linter updates.
If trying to decide where to test, please use the supplied Vagrant VM(s)
outlined in the CONTRIBUTING guide. Primary test envs: Ubuntu, AWS, Kali.
-->
- [ ] Tested _BUG_OR_FEATURE_ on **SERVER** with _OPERATING_SYSTEM_WITH_VERSION_ (_VM_OR_CLOUD_OR_HARDWARE_)
<details>

Steps:
1. Access the **SERVER**
2. Navigate to _MENU_ITEM_
3. Observe _EXPECTED_RESULT_
    SCREENSHOT_OR_VIDEO_HERE
</details>

---
- [ ] Tested _BUG_OR_FEATURE_ on **ENDPOINT** with _OPERATING_SYSTEM_WITH_VERSION_ (_VM_OR_CLOUD_OR_HARDWARE_)
<details>

Steps:
1. Access the **ENDPOINT**
2. Navigate to _MENU_ITEM_
3. Observe _EXPECTED_RESULT_
    SCREENSHOT_OR_VIDEO_HERE
</details>

<!-- Someday!
---
- [ ] This change adds automated test coverage for FEATURE
-->

## Release Note

<!--
See sample release notes here: https://git.k8s.io/community/contributors/guide/release-notes.md
- If no release note is needed, write 'None'
- If you would like us to create one, write 'SUGGESTIONS_WELCOME'
- If this PR contains multiple Release Note worthy items, put one per line in
  the block (Next time, try to break it up into multiple PRs, but we have
  definitely all done it before, so no worries!)
-->
```release-note
ONE_LINE_RELEASE_NOTE_HERE
```

<!-- Links -->
[Code of Conduct]: https://github.com/schlpr0k/IronJump/tree/main/.github/CODE_OF_CONDUCT.md
[CONTRIBUTING]:    https://github.com/schlpr0k/IronJump/tree/main/.github/CONTRIBUTING.md
