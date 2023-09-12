# Core

**TODO: Add description**

```bash
bash> mix new core --sup
bash> mix run apps/core/priv/repo/seeds.exs
```

### `Ecto.Migration`

```sql
BEGIN;
CREATE TABLE IF NOT EXISTS public."operator_types"
(
    id uuid NOT NULL,
    active boolean NOT NULL DEFAULT true,
    inserted_at timestamp without time zone --дата та час додавання запису
    name uuid NOT NULL, --назва типу оператора - gsm, email,  messager
    priority integer, -- пріорітет серед типів операторів
);

CREATE TABLE IF NOT EXISTS public."operators"
-- таблиця яку додаються оператори зв'язку, ціни за 1 повідомлення, пріорітет відправки, ліміти відправки
(
    id uuid NOT NULL,
    active boolean, -- активний або ні оператор. Якщо = false - даний оператор не бере учать в "пріотерізації" повідомлення
    config jsonb,
    inserted_at timestamp without time zone --дата та час додавання запису
    limit_count integer, -- ліміт кількості повідомлень
    name character varying NOT NULL, -- назва оператору зв'язку (Вудафон, киевстар ect)
    operator_type_id uuid NOT NULL, -- id типу опретатора, таблиця OperatorType
    price_ext real NOT NULL DEFAULT 0.000, -- ціна за 1 смс в в інші мережі
    price_int real NOT NULL DEFAULT 0.000, -- ціна за 1 смс в мережі оператора
    priority integer, --пріорітет оператора
);

CREATE TABLE IF NOT EXISTS public.messages
--Таблиця в записуються дані повідомлення отриманих з методу "створення повідомлення"
(
    id uuid NOT NULL, --унікальний ідентифікатор
    email character varying(100), -- email отримувача
    id_external uuid, --унікальний ідентифікатор повідомлення Клієнту
    id_tax character varying(10), -- ІПН(ИНН) для відоправки повідомлень через "Дія"
    inserted_at timestamp without time zone NOT NULL, --дата та час додавання запису
    message_body character varying(255) NOT NULL, -- текст повідомлення
    message_expired_at timestamp without time zone --дата та час "життя" повідомлення, якщо значення більше ніж поточий час повідомлення відправляти не потрібно, Робимо запис в sms_log з значенням статусу "expired"
    phone_number character varying(13) COLLATE pg_catalog."default" NOT NULL, --номер телефону
    status character varying(50) COLLATE pg_catalog."default" NOT NULL, -- статус повідомлення
    telegram character varying(100), -- ID "месенджера" (viber\telegram)
    viber character varying(100), -- ID "месенджера" (viber\telegram)
);

CREATE TABLE IF NOT EXISTS public.sms_logs
(
    id uuid NOT NULL,
    email character varying, -- email отримувача
    id_external uuid, --унікальний ідентифікатор повідомлення Клієнту
    id_tax character varying(10), -- ІПН(ИНН) для відоправки повідомлень через "Дія"
    inserted_at timestamp without time zone NOT NULL, --дата та час додавання запису
    message_expired_at timestamp without time zone NOT NULL, --дата та час "життя" повідомлення
    message_id uuid, --ідентифікатор повідомлення (таблиця message)
    operator_id uuid NOT NULL, --id оператора зв'язку, таблиця "operators"
    operator_name character varying NOT NULL, --id оператора зв'язку, таблиця "operators"
    phone character varying(13) COLLATE pg_catalog."default" NOT NULL, --номер телефону
    priority integer NOT NULL --номер пріорітету за яким було відправлено повідомлення
    status character varying(50) COLLATE pg_catalog."default" NOT NULL, -- статус повідомлення
    statuschanged_at timestamp without time zone NOT NULL, --дата та час додавання запису
    telegram character varying(100), -- ID "месенджера" (viber\telegram)	message_body character varying NOT NULL,-- текст повідомлення
    viber character varying(100), -- ID "месенджера" (viber\telegram)
);
END;
```

```bash
bash> mix ecto.gen.migration -r Core.Repo add_uuid_generate_v4_extension
bash> mix ecto.gen.migration -r Core.Repo create_operator_types
bash> mix ecto.gen.migration -r Core.Repo create_operators
bash> mix ecto.gen.migration -r Core.Repo create_sms_logs
bash> mix ecto.gen.migration -r Core.Repo create_messages
```

### 5 September 2023 by Oleg G.Kapranov
