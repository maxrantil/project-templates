#!/usr/bin/env python3
# ABOUTME: Tests for CUSTOMIZATION.md documentation accuracy and completeness

"""
Test suite for validating CUSTOMIZATION.md documentation.

Tests verify that:
1. All documented commands are syntactically correct
2. All referenced files exist in templates
3. All code examples use correct syntax
4. Workflow references use 'master' branch
5. Links point to valid locations
"""

import re
import subprocess
import tempfile
from pathlib import Path
from typing import List, Tuple

import pytest


class TestPythonCustomizationDoc:
    """Tests for python-project/CUSTOMIZATION.md"""

    @pytest.fixture
    def doc_path(self) -> Path:
        return Path(__file__).parent.parent / "python-project" / "CUSTOMIZATION.md"

    @pytest.fixture
    def template_root(self) -> Path:
        return Path(__file__).parent.parent / "python-project"

    @pytest.fixture
    def doc_content(self, doc_path: Path) -> str:
        return doc_path.read_text()

    def test_doc_exists(self, doc_path: Path) -> None:
        """Verify CUSTOMIZATION.md exists"""
        assert doc_path.exists(), "CUSTOMIZATION.md not found"

    def test_all_referenced_files_exist(
        self, doc_content: str, template_root: Path
    ) -> None:
        """Verify all files mentioned in doc exist in template"""
        # Extract file references like "File: `path/to/file`"
        file_pattern = r"File[^`]*`([^`]+)`"
        referenced_files = re.findall(file_pattern, doc_content)

        missing_files = []
        for file_path in referenced_files:
            full_path = template_root / file_path
            if not full_path.exists():
                missing_files.append(file_path)

        assert not missing_files, f"Referenced files not found: {missing_files}"

    def test_workflow_references_use_master_branch(self, doc_content: str) -> None:
        """Verify all workflow references use @master, not @main"""
        # Find workflow references
        workflow_refs = re.findall(r"@(master|main)", doc_content)

        main_refs = [ref for ref in workflow_refs if ref == "main"]
        assert not main_refs, f"Found {len(main_refs)} references to @main (should be @master)"

    def test_bash_commands_are_valid(self, doc_content: str) -> None:
        """Verify bash code blocks have valid syntax"""
        # Extract bash code blocks
        bash_pattern = r"```bash\n(.*?)\n```"
        bash_blocks = re.findall(bash_pattern, doc_content, re.DOTALL)

        invalid_blocks = []
        for idx, block in enumerate(bash_blocks):
            # Skip blocks with placeholders or comments-only
            if any(
                marker in block
                for marker in ["your-project", "...", "# ", "echo ", "curl "]
            ):
                continue

            # Test syntax with bash -n
            result = subprocess.run(
                ["bash", "-n"],
                input=block,
                text=True,
                capture_output=True,
            )

            if result.returncode != 0:
                invalid_blocks.append((idx, result.stderr))

        assert not invalid_blocks, f"Invalid bash syntax in blocks: {invalid_blocks}"

    def test_yaml_examples_are_valid(self, doc_content: str) -> None:
        """Verify YAML code blocks have valid syntax"""
        yaml_pattern = r"```yaml\n(.*?)\n```"
        yaml_blocks = re.findall(yaml_pattern, doc_content, re.DOTALL)

        try:
            import yaml
        except ImportError:
            pytest.skip("PyYAML not available for YAML validation")

        invalid_blocks = []
        for idx, block in enumerate(yaml_blocks):
            try:
                yaml.safe_load(block)
            except yaml.YAMLError as e:
                invalid_blocks.append((idx, str(e)))

        assert not invalid_blocks, f"Invalid YAML syntax in blocks: {invalid_blocks}"

    def test_uv_commands_use_correct_syntax(self, doc_content: str) -> None:
        """Verify all UV commands follow UV guidelines (no pip, no @latest)"""
        # Find forbidden commands
        forbidden_patterns = [
            (r"uv pip install", "Use 'uv add' not 'uv pip install'"),
            (r"@latest", "UV doesn't support @latest syntax"),
        ]

        violations = []
        for pattern, message in forbidden_patterns:
            matches = re.findall(pattern, doc_content)
            if matches:
                violations.append(f"{message}: found {len(matches)} occurrences")

        assert not violations, f"UV command violations: {violations}"

    def test_has_essential_sections(self, doc_content: str) -> None:
        """Verify documentation has all essential sections"""
        required_sections = [
            "Quick Start",
            "Customization Checklist",
            "Update Project Metadata",
            "Update README",
            "Workflow Customization",
            "Testing Your Customizations",
            "Troubleshooting",
        ]

        missing_sections = []
        for section in required_sections:
            if section not in doc_content:
                missing_sections.append(section)

        assert (
            not missing_sections
        ), f"Missing required sections: {missing_sections}"

    def test_links_are_well_formed(self, doc_content: str) -> None:
        """Verify all markdown links have valid syntax"""
        # Check for broken link syntax
        link_pattern = r"\[([^\]]+)\]\(([^\)]+)\)"
        links = re.findall(link_pattern, doc_content)

        invalid_links = []
        for text, url in links:
            # Check for common issues
            if url.startswith("http") and " " in url:
                invalid_links.append(f"URL contains spaces: {url}")
            if not url.strip():
                invalid_links.append(f"Empty URL for text: {text}")

        assert not invalid_links, f"Invalid link syntax: {invalid_links}"

    def test_checklist_items_are_formatted_correctly(self, doc_content: str) -> None:
        """Verify checklist items use correct markdown syntax"""
        # Find checklist items
        checklist_pattern = r"^(\s*)- \[ \]"
        lines = doc_content.split("\n")

        incorrectly_formatted = []
        for idx, line in enumerate(lines):
            # Check for common formatting errors
            if "- []" in line or "-[ ]" in line or "- [ ]" not in line:
                if "- [ ]" not in line and "[ ]" in line:
                    incorrectly_formatted.append(f"Line {idx+1}: {line.strip()}")

        assert (
            not incorrectly_formatted
        ), f"Incorrectly formatted checklist items: {incorrectly_formatted}"


class TestShellCustomizationDoc:
    """Tests for shell-project/CUSTOMIZATION.md"""

    @pytest.fixture
    def doc_path(self) -> Path:
        return Path(__file__).parent.parent / "shell-project" / "CUSTOMIZATION.md"

    @pytest.fixture
    def template_root(self) -> Path:
        return Path(__file__).parent.parent / "shell-project"

    @pytest.fixture
    def doc_content(self, doc_path: Path) -> str:
        return doc_path.read_text()

    def test_doc_exists(self, doc_path: Path) -> None:
        """Verify CUSTOMIZATION.md exists"""
        assert doc_path.exists(), "CUSTOMIZATION.md not found"

    def test_all_referenced_files_exist(
        self, doc_content: str, template_root: Path
    ) -> None:
        """Verify all files mentioned in doc exist in template"""
        file_pattern = r"File[^`]*`([^`]+)`"
        referenced_files = re.findall(file_pattern, doc_content)

        # Filter out files that are documented as "create if needed"
        optional_files = [".shellcheckrc", ".editorconfig"]

        missing_files = []
        for file_path in referenced_files:
            if file_path in optional_files:
                continue  # These are documented as user-created files
            full_path = template_root / file_path
            if not full_path.exists():
                missing_files.append(file_path)

        assert not missing_files, f"Referenced files not found: {missing_files}"

    def test_workflow_references_use_master_branch(self, doc_content: str) -> None:
        """Verify all workflow references use @master, not @main"""
        workflow_refs = re.findall(r"@(master|main)", doc_content)

        main_refs = [ref for ref in workflow_refs if ref == "main"]
        assert not main_refs, f"Found {len(main_refs)} references to @main (should be @master)"

    def test_shell_examples_follow_best_practices(self, doc_content: str) -> None:
        """Verify shell script examples follow documented best practices"""
        # Extract shell examples
        bash_pattern = r"```bash\n(.*?)\n```"
        bash_blocks = re.findall(bash_pattern, doc_content, re.DOTALL)

        # Only check complete script examples, not command snippets
        script_blocks = [
            block for block in bash_blocks
            if "#!/bin/bash" in block and "main()" in block
        ]

        violations = []
        for idx, block in enumerate(script_blocks):
            # Check for ABOUTME comment (should be right after shebang)
            lines = block.split('\n')
            if len(lines) > 1 and not lines[1].startswith("# ABOUTME:"):
                violations.append(f"Block {idx}: Missing ABOUTME comment after shebang")

            # Check for set -euo pipefail
            if "set -euo pipefail" not in block:
                violations.append(f"Block {idx}: Missing 'set -euo pipefail'")

        assert not violations, f"Shell best practice violations: {violations}"

    def test_shellcheck_commands_are_valid(self, doc_content: str) -> None:
        """Verify ShellCheck command examples use valid options"""
        shellcheck_pattern = r"shellcheck\s+([^\n]+)"
        shellcheck_cmds = re.findall(shellcheck_pattern, doc_content)

        # Just verify we have shellcheck examples - actual validation would require shellcheck installed
        assert len(shellcheck_cmds) > 0, "No shellcheck examples found in documentation"

        # Basic sanity check: no obvious typos
        for cmd in shellcheck_cmds:
            assert "shellchec" not in cmd, f"Possible typo in: shellcheck {cmd}"

    def test_has_shell_best_practices_section(self, doc_content: str) -> None:
        """Verify documentation includes shell best practices"""
        required_practices = [
            "Required Header",
            "Error Handling",
            "Documentation",
        ]

        missing_practices = []
        for practice in required_practices:
            if practice not in doc_content:
                missing_practices.append(practice)

        assert (
            not missing_practices
        ), f"Missing best practices sections: {missing_practices}"


class TestCrossTemplateConsistency:
    """Tests for consistency between Python and Shell customization docs"""

    @pytest.fixture
    def python_doc(self) -> str:
        path = (
            Path(__file__).parent.parent / "python-project" / "CUSTOMIZATION.md"
        )
        return path.read_text()

    @pytest.fixture
    def shell_doc(self) -> str:
        path = Path(__file__).parent.parent / "shell-project" / "CUSTOMIZATION.md"
        return path.read_text()

    def test_both_have_quick_start(self, python_doc: str, shell_doc: str) -> None:
        """Both docs should have Quick Start section"""
        assert "Quick Start" in python_doc
        assert "Quick Start" in shell_doc

    def test_both_have_testing_section(self, python_doc: str, shell_doc: str) -> None:
        """Both docs should have testing instructions"""
        assert "Testing Your Customizations" in python_doc
        assert "Testing Your Customizations" in shell_doc

    def test_both_have_troubleshooting(self, python_doc: str, shell_doc: str) -> None:
        """Both docs should have troubleshooting section"""
        assert "Troubleshooting" in python_doc
        assert "Troubleshooting" in shell_doc

    def test_both_mention_workflow_customization(
        self, python_doc: str, shell_doc: str
    ) -> None:
        """Both docs should explain workflow customization"""
        assert "Workflow Customization" in python_doc
        assert "Workflow Customization" in shell_doc

    def test_both_reference_maxrantil_github(
        self, python_doc: str, shell_doc: str
    ) -> None:
        """Both docs should reference maxrantil/.github for reusable workflows"""
        assert "maxrantil/.github" in python_doc
        assert "maxrantil/.github" in shell_doc

    def test_consistent_section_ordering(
        self, python_doc: str, shell_doc: str
    ) -> None:
        """Major sections should appear in similar order"""
        common_sections = [
            "Quick Start",
            "Customization Checklist",
            "Workflow Customization",
            "Testing Your Customizations",
            "Troubleshooting",
        ]

        python_positions = [python_doc.find(s) for s in common_sections]
        shell_positions = [shell_doc.find(s) for s in common_sections]

        # All sections should exist (positive positions)
        assert all(p > 0 for p in python_positions), "Missing sections in Python doc"
        assert all(p > 0 for p in shell_positions), "Missing sections in Shell doc"

        # Sections should appear in same relative order
        assert python_positions == sorted(python_positions), "Python sections out of order"
        assert shell_positions == sorted(shell_positions), "Shell sections out of order"


class TestDocumentationCompleteness:
    """Tests for documentation completeness and quality"""

    @pytest.fixture(params=["python-project", "shell-project"])
    def doc_path(self, request: pytest.FixtureRequest) -> Path:
        return (
            Path(__file__).parent.parent / request.param / "CUSTOMIZATION.md"
        )

    def test_has_version_footer(self, doc_path: Path) -> None:
        """Each doc should have version/date footer"""
        content = doc_path.read_text()
        assert "Template Version" in content
        assert "Last Updated" in content

    def test_has_getting_help_section(self, doc_path: Path) -> None:
        """Each doc should have getting help information"""
        content = doc_path.read_text()
        assert "Getting Help" in content or "Help" in content

    def test_has_actionable_steps(self, doc_path: Path) -> None:
        """Documentation should have clear action items"""
        content = doc_path.read_text()

        # Count action items (checklists, commands, etc.)
        checklist_items = len(re.findall(r"- \[ \]", content))
        code_blocks = len(re.findall(r"```", content)) // 2  # Each block has 2 markers

        assert checklist_items > 5, "Not enough checklist items for actionable guide"
        assert code_blocks > 10, "Not enough code examples"

    def test_links_to_workflow_documentation(self, doc_path: Path) -> None:
        """Should reference workflow documentation"""
        content = doc_path.read_text()
        assert (
            "workflow" in content.lower() and "github.com/maxrantil" in content
        )


if __name__ == "__main__":
    pytest.main([__file__, "-v"])
