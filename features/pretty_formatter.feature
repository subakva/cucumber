Feature: Pretty output formatter

  Background:
    Given a file named "features/scenario_outline_with_undefined_steps.feature" with:
      """
      Feature:

        Scenario Outline:
          Given an undefined step

        Examples:
          |foo|
          |bar|
      """

  Scenario: an scenario outline, one undefined step, one random example, expand flag on
    When I run `cucumber features/scenario_outline_with_undefined_steps.feature --format pretty --expand `
    Then it should pass

  Scenario: when using a profile the output should include 'Using the default profile...'
    And a file named "cucumber.yml" with:
    """
      default: -r features
    """
    When I run `cucumber --profile default --format pretty`
    Then it should pass
    And the output should contain:
    """
    Using the default profile...
    """

    Scenario: with an expanded scenario outline
      Given a file named "features/step_definitions/pretty_steps.rb" with:
        """
        When /^I see the string "(.*?)"$/ do |some_string|
          # it really doesn't matter
        end
        """
      Given a file named "features/scenario_outline_many_examples.feature" with:
        """
          Feature:

            Scenario Outline: Seeing a long string
              Then I see the string "<long string>"

            Examples:
              | long string |
              | Subsequently, I found that the third episode of "Wormling" was not at all what anyone had expected. Seventeen moles were in attendance. |
        """
      When I run `cucumber features/scenario_outline_many_examples.feature --format pretty --expand`
      Then it should pass
      And the output should contain:
      """
      Then I see the string "Subsequently, I found that the third episode of "Wormling" was not at all what anyone had expected. Seventeen moles were in attendance."
      """

