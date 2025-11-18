local M = {}

M.storybook = function(component_name)
  return string.format([[import type { Meta, StoryObj } from "@storybook/react";
import { %s } from "./%s";

const meta: Meta<typeof %s> = {
  component: %s,
  parameters: {
    layout: "centered",
  },
  decorators: [
    (Story) => (
      <div className="flex justify-center items-center bg-gray-200 w-[400px] h-[100px] p-2 border border-gray-200">
        <Story />
      </div>
    ),
  ],
};

export default meta;
type Story = StoryObj<typeof meta>;

export const %sStory: Story = {
  args: {},
};
]], component_name, component_name, component_name, component_name, component_name)
end

M.test_typescript = function(module_name, source_file)
  return string.format([[import { describe, it, expect } from 'vitest';
import { %s } from './%s';

describe('%s', () => {
  it('should work', () => {
    expect(true).toBe(true);
  });
});
]], module_name, source_file, module_name)
end

M.test_javascript = function(module_name, source_file)
  return string.format([[import { describe, it, expect } from 'vitest';
import { %s } from './%s';

describe('%s', () => {
  it('should work', () => {
    expect(true).toBe(true);
  });
});
]], module_name, source_file, module_name)
end

M.test_python = function(module_name)
  return string.format([[import pytest
from %s import *


def test_%s():
    """Test %s functionality."""
    assert True
]], module_name, module_name, module_name)
end

return M
