module SemVar

import SemVar.Lexer
import SemVar.Parser
import public SemVar.Data

||| Parse a Version
export
parseVersion : String -> Maybe Version
parseVersion x = parseVersionToks !(lexSemVar x)

||| Parse a Requirement
export
parseRequirement : String -> Maybe Requirement
parseRequirement x = parseRequirementToks !(lexSemVar x)
