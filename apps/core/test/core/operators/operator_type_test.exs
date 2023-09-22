defmodule Core.Operators.OperatorTypeTest do
  use Core.DataCase

  describe "Status" do
    alias Core.{
      Operators,
      Operators.OperatorType,
      Repo,
    }

    @valid_attrs %{
      active: true,
      name_type: "some text",
      priority: 1
    }

    @update_attrs %{
      active: false,
      name_type: "updated some text",
      priority: 2
    }

    @invalid_attrs %{
      active: nil,
      name_type: nil
    }

    test "list_operator_type/0 with empty list" do
      data = Operators.list_operator_type()
      assert data == []
      assert Enum.empty?(data) == true
    end

    test "list_operator_type/0 with data" do
      operator_type = insert(:operator_type)
      data = Operators.list_operator_type()
      assert Repo.preload(data, [:operator]) == [operator_type]
      assert Enum.count(data) == 1
    end

    test "create_operator_type/1" do
      assert {:ok, %OperatorType{} = created} = Operators.create_operator_type(@valid_attrs)
      assert created.active    == @valid_attrs.active
      assert created.name_type == @valid_attrs.name_type
      assert created.priority  == @valid_attrs.priority
    end

    test "create_operator_type/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Operators.create_operator_type(@invalid_attrs)
    end

    test "get_operator_type/1" do
      operator_type = insert(:operator_type)
      struct = Operators.get_operator_type(operator_type.id)
      assert struct.id        == operator_type.id
      assert struct.active    == operator_type.active
      assert struct.name_type == operator_type.name_type
      assert struct.priority  == operator_type.priority
    end

    test "get_operator_type/1 with invalid id returns error changeset" do
      operator_type_id = FlakeId.get()
      assert {:error, %Ecto.Changeset{}} = Operators.get_operator_type(operator_type_id)
    end

    test "update_operator_type/2" do
      operator_type = insert(:operator_type)
      {:ok, struct} = Operators.update_operator_type(operator_type, @update_attrs)
      assert struct.active    == @update_attrs.active
      assert struct.name_type == @update_attrs.name_type
      assert struct.priority  == @update_attrs.priority
    end

    test "update_operator_type/2 with nil active" do
      operator_type = insert(:operator_type)
      update_attrs = %{active: nil, name_type: @update_attrs.name_type, priority: @update_attrs.priority}
      assert {:error, %Ecto.Changeset{}} = Operators.update_operator_type(operator_type, update_attrs)
    end

    test "update_operator_type/2 with nil name_type" do
      operator_type = insert(:operator_type)
      update_attrs = %{active: @update_attrs.active, name_type: nil}
      assert {:error, %Ecto.Changeset{}} = Operators.update_operator_type(operator_type, update_attrs)
    end

    test "update_operator_type/2 with empty parameter" do
      operator_type = insert(:operator_type)
      {:ok, struct} = Operators.update_operator_type(operator_type, %{})
      assert struct.active    == operator_type.active
      assert struct.name_type == operator_type.name_type
      assert struct.priority  == operator_type.priority
    end

    test "update_operator_type/2 with invalid struct returns error changeset" do
      operator_type = %OperatorType{}
      assert {:error, %Ecto.Changeset{}} = Operators.update_operator_type(operator_type, %{})
    end

    test "change_operator_type/1" do
      operator_type = insert(:operator_type)
      assert %Ecto.Changeset{} = Operators.change_operator_type(operator_type)
    end

    test "change_operator_type/1 with empty struct" do
      assert %Ecto.Changeset{} = Operators.change_operator_type(%OperatorType{})
    end
  end
end
