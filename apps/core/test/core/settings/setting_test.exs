defmodule Core.Settings.SettingTest do
  use Core.DataCase

  describe "Status" do
    alias Core.{
      Settings,
      Settings.Setting
    }

    @valid_attrs %{
      param: "some text",
      value: "some text"
    }

    @update_attrs %{
      param: "updated some text",
      value: "updated some text"
    }

    @invalid_attrs %{
      param: nil,
      value: nil
    }

    test "list_setting/0 with empty list" do
      data = Settings.list_setting()
      assert data == []
      assert Enum.count(data) == 0
    end


    test "list_setting/0 with data" do
      setting = insert(:setting)
      data = Settings.list_setting()
      assert data == [setting]
      assert Enum.count(data) == 1
    end

    test "create_setting/1" do
      assert {:ok, %Setting{} = created} = Settings.create_setting(@valid_attrs)
      assert created.param == @valid_attrs.param
      assert created.value == @valid_attrs.value
    end

    test "create_setting/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Settings.create_setting(@invalid_attrs)
    end

    test "get_setting/1" do
      setting = insert(:setting)
      struct = Settings.get_setting(setting.id)
      assert struct.id    == setting.id
      assert struct.param == setting.param
      assert struct.value == setting.value
    end

    test "get_setting/1 with invalid id returns error changeset" do
      setting_id = FlakeId.get()
      assert {:error, %Ecto.Changeset{}} = Settings.get_setting(setting_id)
    end

    test "update_setting/2" do
      setting = insert(:setting)
      {:ok, struct} = Settings.update_setting(setting, @update_attrs)
      assert struct.param == @update_attrs.param
      assert struct.value == @update_attrs.value
    end

    test "update_setting/2 with nil param" do
      setting = insert(:setting)
      update_attrs = %{param: nil, value: @update_attrs.value}
      assert {:error, %Ecto.Changeset{}} = Settings.update_setting(setting, update_attrs)
    end

    test "update_setting/2 with nil value" do
      setting = insert(:setting)
      update_attrs = %{param: @update_attrs.param, value: nil}
      assert {:error, %Ecto.Changeset{}} = Settings.update_setting(setting, update_attrs)
    end

    test "update_setting/2 with empty param" do
      setting = insert(:setting)
      {:ok, struct} = Settings.update_setting(setting, %{})
      assert struct.param == setting.param
      assert struct.value == setting.value
    end

    test "update_setting/2 with invalid struct returns error changeset" do
      setting = %Setting{}
      assert {:error, %Ecto.Changeset{}} = Settings.update_setting(setting, %{})
    end
  end
end
