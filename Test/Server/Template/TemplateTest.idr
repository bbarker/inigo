module Test.Server.Template.TemplateTest

import IdrTest.Test
import IdrTest.Expectation

import Server.Template.Template

%default total

export
suite : Test
suite =
  describe "Template Tests"
    [ test "Show Template" (\_ => assertEq
        (template "My Template <%% DESC %%>" [("DESC","Rocks")])
        "My Template Rocks"
      )
    ]
