-- CreateEnum
CREATE TYPE "UserRole" AS ENUM ('ADMIN', 'NORMAL_USER', 'MANAGER', 'REALIZATION_OFFICER', 'PROCUREMENT_AUTHORITY');

-- CreateEnum
CREATE TYPE "UserStatus" AS ENUM ('ACTIVE', 'INACTIVE');

-- CreateEnum
CREATE TYPE "RequestType" AS ENUM ('GOODS', 'SERVICE', 'CONSTRUCTION');

-- CreateEnum
CREATE TYPE "MaterialRequestStatus" AS ENUM ('DRAFT', 'SUBMITTED', 'PROCESSED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "ProcurementStatus" AS ENUM ('DRAFT', 'PREPARING', 'READY_FOR_EKAP', 'ANNOUNCED', 'QUOTATION_COLLECTION', 'EVALUATION', 'DECISION_PENDING', 'DECISION_APPROVED', 'APPROVAL_PENDING', 'APPROVED', 'ORDERING', 'PARTIALLY_DELIVERED', 'DELIVERED', 'INVOICED', 'COMPLETED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "ProcurementMethod" AS ENUM ('DIRECT_PROCUREMENT', 'OTHER');

-- CreateEnum
CREATE TYPE "RFQStatus" AS ENUM ('DRAFT', 'SENT', 'QUOTATION_COLLECTION', 'CLOSED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "SupplierStatus" AS ENUM ('ACTIVE', 'INACTIVE', 'BLOCKED');

-- CreateEnum
CREATE TYPE "QuotationStatus" AS ENUM ('RECEIVED', 'UNDER_EVALUATION', 'ACCEPTED', 'PARTIALLY_ACCEPTED', 'REJECTED');

-- CreateEnum
CREATE TYPE "EvaluationType" AS ENUM ('SAMPLE', 'DEMONSTRATION', 'CATALOG', 'VISUAL', 'TECHNICAL', 'OTHER');

-- CreateEnum
CREATE TYPE "EvaluationResult" AS ENUM ('ACCEPTED', 'REJECTED', 'CONDITIONAL');

-- CreateEnum
CREATE TYPE "DecisionStatus" AS ENUM ('DRAFT', 'PENDING_SIGNATURE', 'SIGNED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "SignatureStage" AS ENUM ('DECISION', 'APPROVAL');

-- CreateEnum
CREATE TYPE "SignatureRole" AS ENUM ('CHAIRPERSON', 'MEMBER', 'REALIZATION_OFFICER', 'PROCUREMENT_AUTHORITY');

-- CreateEnum
CREATE TYPE "OrderStatus" AS ENUM ('DRAFT', 'APPROVED', 'SENT', 'PARTIALLY_DELIVERED', 'DELIVERED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "InvoiceStatus" AS ENUM ('RECEIVED', 'APPROVED', 'PAID', 'REJECTED');

-- CreateEnum
CREATE TYPE "DeliveryStatus" AS ENUM ('PENDING', 'PARTIALLY_DELIVERED', 'DELIVERED', 'OVERDUE');

-- CreateEnum
CREATE TYPE "DocumentType" AS ENUM ('MATERIAL_REQUEST', 'ADMINISTRATIVE_SPECIFICATION', 'CONTRACT_DRAFT', 'RFQ', 'QUOTATION', 'CATALOG', 'SAMPLE', 'DEMONSTRATION', 'DECISION', 'APPROVAL', 'PURCHASE_ORDER', 'DELIVERY', 'INVOICE', 'OTHER');

-- CreateTable
CREATE TABLE "users" (
    "id" UUID NOT NULL,
    "authUserId" UUID NOT NULL,
    "email" TEXT NOT NULL,
    "firstName" TEXT NOT NULL,
    "lastName" TEXT NOT NULL,
    "status" "UserStatus" NOT NULL DEFAULT 'ACTIVE',
    "departmentId" UUID,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_role_assignments" (
    "id" UUID NOT NULL,
    "userId" UUID NOT NULL,
    "role" "UserRole" NOT NULL,

    CONSTRAINT "user_role_assignments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "employees" (
    "id" UUID NOT NULL,
    "employeeCode" TEXT,
    "firstName" TEXT NOT NULL,
    "lastName" TEXT NOT NULL,
    "title" TEXT,
    "departmentId" UUID,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "employees_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "departments" (
    "id" UUID NOT NULL,
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "departments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "material_requests" (
    "id" UUID NOT NULL,
    "requestNumber" TEXT NOT NULL,
    "departmentId" UUID NOT NULL,
    "createdById" UUID NOT NULL,
    "requestDate" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "status" "MaterialRequestStatus" NOT NULL DEFAULT 'DRAFT',
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "material_requests_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "material_request_items" (
    "id" UUID NOT NULL,
    "materialRequestId" UUID NOT NULL,
    "itemNumber" INTEGER NOT NULL,
    "materialName" TEXT NOT NULL,
    "unit" TEXT NOT NULL,
    "quantity" DECIMAL(18,4) NOT NULL,
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "material_request_items_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "procurements" (
    "id" UUID NOT NULL,
    "procurementNumber" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "procurementDate" TIMESTAMP(3) NOT NULL,
    "departmentId" UUID NOT NULL,
    "createdById" UUID NOT NULL,
    "requestType" "RequestType" NOT NULL,
    "method" "ProcurementMethod" NOT NULL DEFAULT 'DIRECT_PROCUREMENT',
    "status" "ProcurementStatus" NOT NULL DEFAULT 'DRAFT',
    "ekapDirectProcurementId" TEXT,
    "directProcurementName" TEXT,
    "paymentTermDays" INTEGER,
    "additionalClause" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "procurements_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "procurement_material_requests" (
    "id" UUID NOT NULL,
    "procurementId" UUID NOT NULL,
    "materialRequestId" UUID NOT NULL,

    CONSTRAINT "procurement_material_requests_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "procurement_items" (
    "id" UUID NOT NULL,
    "procurementId" UUID NOT NULL,
    "materialRequestItemId" UUID,
    "itemNumber" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "unit" TEXT NOT NULL,
    "quantity" DECIMAL(18,4) NOT NULL,
    "sutCode" TEXT,
    "sutPrice" DECIMAL(18,2),
    "budgetCode" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "procurement_items_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "administrative_specifications" (
    "id" UUID NOT NULL,
    "procurementId" UUID NOT NULL,
    "procurementDate" TIMESTAMP(3) NOT NULL,
    "ekapDirectProcurementId" TEXT NOT NULL,
    "directProcurementName" TEXT NOT NULL,
    "paymentTermDays" INTEGER,
    "additionalClause" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "administrative_specifications_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "contract_drafts" (
    "id" UUID NOT NULL,
    "procurementId" UUID NOT NULL,
    "ekapDirectProcurementId" TEXT NOT NULL,
    "directProcurementName" TEXT NOT NULL,
    "finalGuaranteeRequired" BOOLEAN NOT NULL DEFAULT false,
    "contractDurationDays" INTEGER,
    "startDate" TIMESTAMP(3),
    "endDate" TIMESTAMP(3),
    "paymentTermDays" INTEGER,
    "additionalClause" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "contract_drafts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "rfqs" (
    "id" UUID NOT NULL,
    "rfqNumber" TEXT NOT NULL,
    "procurementId" UUID NOT NULL,
    "createdById" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "sentAt" TIMESTAMP(3),
    "deadline" TIMESTAMP(3),
    "status" "RFQStatus" NOT NULL DEFAULT 'DRAFT',

    CONSTRAINT "rfqs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "rfq_suppliers" (
    "id" UUID NOT NULL,
    "rfqId" UUID NOT NULL,
    "supplierId" UUID NOT NULL,
    "invitedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "rfq_suppliers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "rfq_items" (
    "id" UUID NOT NULL,
    "rfqId" UUID NOT NULL,
    "procurementItemId" UUID NOT NULL,
    "itemNumber" INTEGER NOT NULL,
    "description" TEXT NOT NULL,
    "unit" TEXT NOT NULL,
    "quantity" DECIMAL(18,4) NOT NULL,

    CONSTRAINT "rfq_items_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "suppliers" (
    "id" UUID NOT NULL,
    "supplierCode" TEXT NOT NULL,
    "companyName" TEXT NOT NULL,
    "taxId" TEXT,
    "email" TEXT,
    "phone" TEXT,
    "website" TEXT,
    "address" TEXT,
    "city" TEXT,
    "country" TEXT,
    "contactName" TEXT,
    "status" "SupplierStatus" NOT NULL DEFAULT 'ACTIVE',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "suppliers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "quotations" (
    "id" UUID NOT NULL,
    "quotationNumber" TEXT NOT NULL,
    "rfqId" UUID NOT NULL,
    "supplierId" UUID NOT NULL,
    "createdById" UUID,
    "receivedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "validUntil" TIMESTAMP(3),
    "currency" TEXT NOT NULL DEFAULT 'TRY',
    "subtotal" DECIMAL(18,2),
    "taxTotal" DECIMAL(18,2),
    "grandTotal" DECIMAL(18,2),
    "status" "QuotationStatus" NOT NULL DEFAULT 'RECEIVED',
    "notes" TEXT,

    CONSTRAINT "quotations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "quotation_items" (
    "id" UUID NOT NULL,
    "quotationId" UUID NOT NULL,
    "rfqItemId" UUID NOT NULL,
    "quantity" DECIMAL(18,4) NOT NULL,
    "unitPrice" DECIMAL(18,2) NOT NULL,
    "taxRate" DECIMAL(5,2),
    "taxAmount" DECIMAL(18,2),
    "total" DECIMAL(18,2) NOT NULL,
    "notes" TEXT,

    CONSTRAINT "quotation_items_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "evaluations" (
    "id" UUID NOT NULL,
    "quotationId" UUID NOT NULL,
    "type" "EvaluationType" NOT NULL,
    "result" "EvaluationResult" NOT NULL,
    "evaluatorId" UUID,
    "score" DECIMAL(5,2),
    "notes" TEXT,
    "evaluatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "evaluations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "procurement_decisions" (
    "id" UUID NOT NULL,
    "procurementId" UUID NOT NULL,
    "partialOfferAllowed" BOOLEAN NOT NULL DEFAULT false,
    "status" "DecisionStatus" NOT NULL DEFAULT 'DRAFT',
    "generalReason" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "procurement_decisions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "procurement_decision_items" (
    "id" UUID NOT NULL,
    "decisionId" UUID NOT NULL,
    "procurementItemId" UUID NOT NULL,
    "supplierId" UUID NOT NULL,
    "quotationId" UUID NOT NULL,
    "quotationItemId" UUID NOT NULL,
    "quantity" DECIMAL(18,4) NOT NULL,
    "unitPrice" DECIMAL(18,2) NOT NULL,
    "rank" INTEGER,
    "systemRecommended" BOOLEAN NOT NULL DEFAULT false,
    "userSelected" BOOLEAN NOT NULL DEFAULT false,
    "selectionReason" TEXT,
    "decisionNote" TEXT,

    CONSTRAINT "procurement_decision_items_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "signatures" (
    "id" UUID NOT NULL,
    "procurementId" UUID NOT NULL,
    "decisionId" UUID,
    "userId" UUID NOT NULL,
    "stage" "SignatureStage" NOT NULL,
    "role" "SignatureRole" NOT NULL,
    "signedAt" TIMESTAMP(3),
    "isSigned" BOOLEAN NOT NULL DEFAULT false,
    "signatureOrder" INTEGER NOT NULL,
    "comment" TEXT,

    CONSTRAINT "signatures_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "purchase_orders" (
    "id" UUID NOT NULL,
    "orderNumber" TEXT NOT NULL,
    "procurementId" UUID NOT NULL,
    "supplierId" UUID NOT NULL,
    "createdById" UUID NOT NULL,
    "status" "OrderStatus" NOT NULL DEFAULT 'DRAFT',
    "orderDate" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expectedDeliveryDate" TIMESTAMP(3),
    "deliveryAddress" TEXT,
    "deliveryNotes" TEXT,
    "subtotal" DECIMAL(18,2),
    "taxTotal" DECIMAL(18,2),
    "grandTotal" DECIMAL(18,2),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "purchase_orders_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "purchase_order_items" (
    "id" UUID NOT NULL,
    "purchaseOrderId" UUID NOT NULL,
    "procurementItemId" UUID NOT NULL,
    "itemNumber" INTEGER NOT NULL,
    "description" TEXT NOT NULL,
    "quantity" DECIMAL(18,4) NOT NULL,
    "unit" TEXT NOT NULL,
    "unitPrice" DECIMAL(18,2) NOT NULL,
    "taxRate" DECIMAL(5,2),
    "taxAmount" DECIMAL(18,2),
    "total" DECIMAL(18,2) NOT NULL,
    "deliveredQuantity" DECIMAL(18,4) NOT NULL DEFAULT 0,

    CONSTRAINT "purchase_order_items_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "purchase_deliveries" (
    "id" UUID NOT NULL,
    "deliveryNumber" TEXT NOT NULL,
    "purchaseOrderId" UUID NOT NULL,
    "receivedByEmployeeId" UUID,
    "deliveryDate" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "status" "DeliveryStatus" NOT NULL DEFAULT 'PENDING',
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "purchase_deliveries_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "purchase_delivery_items" (
    "id" UUID NOT NULL,
    "deliveryId" UUID NOT NULL,
    "purchaseOrderItemId" UUID NOT NULL,
    "quantity" DECIMAL(18,4) NOT NULL,
    "notes" TEXT,

    CONSTRAINT "purchase_delivery_items_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "invoices" (
    "id" UUID NOT NULL,
    "invoiceNumber" TEXT NOT NULL,
    "supplierId" UUID NOT NULL,
    "purchaseOrderId" UUID,
    "invoiceDate" TIMESTAMP(3) NOT NULL,
    "status" "InvoiceStatus" NOT NULL DEFAULT 'RECEIVED',
    "currency" TEXT NOT NULL DEFAULT 'TRY',
    "subtotal" DECIMAL(18,2),
    "taxTotal" DECIMAL(18,2),
    "grandTotal" DECIMAL(18,2),
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "invoices_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "attachments" (
    "id" UUID NOT NULL,
    "fileName" TEXT NOT NULL,
    "storagePath" TEXT NOT NULL,
    "mimeType" TEXT NOT NULL,
    "sizeBytes" INTEGER,
    "type" "DocumentType" NOT NULL,
    "procurementId" UUID,
    "materialRequestId" UUID,
    "administrativeSpecificationId" UUID,
    "contractDraftId" UUID,
    "rfqId" UUID,
    "quotationId" UUID,
    "evaluationId" UUID,
    "decisionId" UUID,
    "purchaseOrderId" UUID,
    "deliveryId" UUID,
    "invoiceId" UUID,
    "supplierId" UUID,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "attachments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "audit_logs" (
    "id" UUID NOT NULL,
    "userId" UUID,
    "action" TEXT NOT NULL,
    "entityType" TEXT NOT NULL,
    "entityId" TEXT NOT NULL,
    "changes" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "audit_logs_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_authUserId_key" ON "users"("authUserId");

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE INDEX "users_departmentId_idx" ON "users"("departmentId");

-- CreateIndex
CREATE INDEX "users_status_idx" ON "users"("status");

-- CreateIndex
CREATE INDEX "user_role_assignments_role_idx" ON "user_role_assignments"("role");

-- CreateIndex
CREATE UNIQUE INDEX "user_role_assignments_userId_role_key" ON "user_role_assignments"("userId", "role");

-- CreateIndex
CREATE UNIQUE INDEX "employees_employeeCode_key" ON "employees"("employeeCode");

-- CreateIndex
CREATE INDEX "employees_departmentId_idx" ON "employees"("departmentId");

-- CreateIndex
CREATE INDEX "employees_lastName_idx" ON "employees"("lastName");

-- CreateIndex
CREATE UNIQUE INDEX "departments_code_key" ON "departments"("code");

-- CreateIndex
CREATE UNIQUE INDEX "departments_name_key" ON "departments"("name");

-- CreateIndex
CREATE UNIQUE INDEX "material_requests_requestNumber_key" ON "material_requests"("requestNumber");

-- CreateIndex
CREATE INDEX "material_requests_departmentId_idx" ON "material_requests"("departmentId");

-- CreateIndex
CREATE INDEX "material_requests_createdById_idx" ON "material_requests"("createdById");

-- CreateIndex
CREATE INDEX "material_requests_status_idx" ON "material_requests"("status");

-- CreateIndex
CREATE INDEX "material_requests_requestDate_idx" ON "material_requests"("requestDate");

-- CreateIndex
CREATE INDEX "material_request_items_materialRequestId_idx" ON "material_request_items"("materialRequestId");

-- CreateIndex
CREATE UNIQUE INDEX "material_request_items_materialRequestId_itemNumber_key" ON "material_request_items"("materialRequestId", "itemNumber");

-- CreateIndex
CREATE UNIQUE INDEX "procurements_procurementNumber_key" ON "procurements"("procurementNumber");

-- CreateIndex
CREATE INDEX "procurements_departmentId_idx" ON "procurements"("departmentId");

-- CreateIndex
CREATE INDEX "procurements_createdById_idx" ON "procurements"("createdById");

-- CreateIndex
CREATE INDEX "procurements_status_idx" ON "procurements"("status");

-- CreateIndex
CREATE INDEX "procurements_procurementDate_idx" ON "procurements"("procurementDate");

-- CreateIndex
CREATE INDEX "procurements_ekapDirectProcurementId_idx" ON "procurements"("ekapDirectProcurementId");

-- CreateIndex
CREATE INDEX "procurement_material_requests_materialRequestId_idx" ON "procurement_material_requests"("materialRequestId");

-- CreateIndex
CREATE UNIQUE INDEX "procurement_material_requests_procurementId_materialRequest_key" ON "procurement_material_requests"("procurementId", "materialRequestId");

-- CreateIndex
CREATE INDEX "procurement_items_materialRequestItemId_idx" ON "procurement_items"("materialRequestItemId");

-- CreateIndex
CREATE INDEX "procurement_items_procurementId_idx" ON "procurement_items"("procurementId");

-- CreateIndex
CREATE UNIQUE INDEX "procurement_items_procurementId_itemNumber_key" ON "procurement_items"("procurementId", "itemNumber");

-- CreateIndex
CREATE UNIQUE INDEX "administrative_specifications_procurementId_key" ON "administrative_specifications"("procurementId");

-- CreateIndex
CREATE UNIQUE INDEX "contract_drafts_procurementId_key" ON "contract_drafts"("procurementId");

-- CreateIndex
CREATE UNIQUE INDEX "rfqs_rfqNumber_key" ON "rfqs"("rfqNumber");

-- CreateIndex
CREATE INDEX "rfqs_procurementId_idx" ON "rfqs"("procurementId");

-- CreateIndex
CREATE INDEX "rfqs_createdById_idx" ON "rfqs"("createdById");

-- CreateIndex
CREATE INDEX "rfq_suppliers_supplierId_idx" ON "rfq_suppliers"("supplierId");

-- CreateIndex
CREATE UNIQUE INDEX "rfq_suppliers_rfqId_supplierId_key" ON "rfq_suppliers"("rfqId", "supplierId");

-- CreateIndex
CREATE INDEX "rfq_items_procurementItemId_idx" ON "rfq_items"("procurementItemId");

-- CreateIndex
CREATE UNIQUE INDEX "rfq_items_rfqId_itemNumber_key" ON "rfq_items"("rfqId", "itemNumber");

-- CreateIndex
CREATE UNIQUE INDEX "suppliers_supplierCode_key" ON "suppliers"("supplierCode");

-- CreateIndex
CREATE UNIQUE INDEX "suppliers_taxId_key" ON "suppliers"("taxId");

-- CreateIndex
CREATE INDEX "suppliers_companyName_idx" ON "suppliers"("companyName");

-- CreateIndex
CREATE INDEX "suppliers_taxId_idx" ON "suppliers"("taxId");

-- CreateIndex
CREATE INDEX "suppliers_status_idx" ON "suppliers"("status");

-- CreateIndex
CREATE UNIQUE INDEX "quotations_quotationNumber_key" ON "quotations"("quotationNumber");

-- CreateIndex
CREATE INDEX "quotations_rfqId_idx" ON "quotations"("rfqId");

-- CreateIndex
CREATE INDEX "quotations_supplierId_idx" ON "quotations"("supplierId");

-- CreateIndex
CREATE INDEX "quotations_createdById_idx" ON "quotations"("createdById");

-- CreateIndex
CREATE INDEX "quotation_items_rfqItemId_idx" ON "quotation_items"("rfqItemId");

-- CreateIndex
CREATE UNIQUE INDEX "quotation_items_quotationId_rfqItemId_key" ON "quotation_items"("quotationId", "rfqItemId");

-- CreateIndex
CREATE INDEX "evaluations_quotationId_idx" ON "evaluations"("quotationId");

-- CreateIndex
CREATE INDEX "evaluations_evaluatorId_idx" ON "evaluations"("evaluatorId");

-- CreateIndex
CREATE UNIQUE INDEX "procurement_decisions_procurementId_key" ON "procurement_decisions"("procurementId");

-- CreateIndex
CREATE INDEX "procurement_decision_items_decisionId_idx" ON "procurement_decision_items"("decisionId");

-- CreateIndex
CREATE INDEX "procurement_decision_items_procurementItemId_idx" ON "procurement_decision_items"("procurementItemId");

-- CreateIndex
CREATE INDEX "procurement_decision_items_supplierId_idx" ON "procurement_decision_items"("supplierId");

-- CreateIndex
CREATE INDEX "signatures_procurementId_stage_idx" ON "signatures"("procurementId", "stage");

-- CreateIndex
CREATE INDEX "signatures_userId_idx" ON "signatures"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "purchase_orders_orderNumber_key" ON "purchase_orders"("orderNumber");

-- CreateIndex
CREATE INDEX "purchase_orders_procurementId_idx" ON "purchase_orders"("procurementId");

-- CreateIndex
CREATE INDEX "purchase_orders_supplierId_idx" ON "purchase_orders"("supplierId");

-- CreateIndex
CREATE INDEX "purchase_orders_status_idx" ON "purchase_orders"("status");

-- CreateIndex
CREATE INDEX "purchase_orders_expectedDeliveryDate_idx" ON "purchase_orders"("expectedDeliveryDate");

-- CreateIndex
CREATE INDEX "purchase_order_items_procurementItemId_idx" ON "purchase_order_items"("procurementItemId");

-- CreateIndex
CREATE UNIQUE INDEX "purchase_order_items_purchaseOrderId_itemNumber_key" ON "purchase_order_items"("purchaseOrderId", "itemNumber");

-- CreateIndex
CREATE UNIQUE INDEX "purchase_deliveries_deliveryNumber_key" ON "purchase_deliveries"("deliveryNumber");

-- CreateIndex
CREATE INDEX "purchase_deliveries_purchaseOrderId_idx" ON "purchase_deliveries"("purchaseOrderId");

-- CreateIndex
CREATE INDEX "purchase_deliveries_receivedByEmployeeId_idx" ON "purchase_deliveries"("receivedByEmployeeId");

-- CreateIndex
CREATE INDEX "purchase_delivery_items_deliveryId_idx" ON "purchase_delivery_items"("deliveryId");

-- CreateIndex
CREATE INDEX "purchase_delivery_items_purchaseOrderItemId_idx" ON "purchase_delivery_items"("purchaseOrderItemId");

-- CreateIndex
CREATE INDEX "invoices_purchaseOrderId_idx" ON "invoices"("purchaseOrderId");

-- CreateIndex
CREATE INDEX "invoices_status_idx" ON "invoices"("status");

-- CreateIndex
CREATE UNIQUE INDEX "invoices_supplierId_invoiceNumber_key" ON "invoices"("supplierId", "invoiceNumber");

-- CreateIndex
CREATE INDEX "attachments_procurementId_idx" ON "attachments"("procurementId");

-- CreateIndex
CREATE INDEX "attachments_materialRequestId_idx" ON "attachments"("materialRequestId");

-- CreateIndex
CREATE INDEX "attachments_administrativeSpecificationId_idx" ON "attachments"("administrativeSpecificationId");

-- CreateIndex
CREATE INDEX "attachments_contractDraftId_idx" ON "attachments"("contractDraftId");

-- CreateIndex
CREATE INDEX "attachments_rfqId_idx" ON "attachments"("rfqId");

-- CreateIndex
CREATE INDEX "attachments_quotationId_idx" ON "attachments"("quotationId");

-- CreateIndex
CREATE INDEX "attachments_evaluationId_idx" ON "attachments"("evaluationId");

-- CreateIndex
CREATE INDEX "attachments_decisionId_idx" ON "attachments"("decisionId");

-- CreateIndex
CREATE INDEX "attachments_purchaseOrderId_idx" ON "attachments"("purchaseOrderId");

-- CreateIndex
CREATE INDEX "attachments_deliveryId_idx" ON "attachments"("deliveryId");

-- CreateIndex
CREATE INDEX "attachments_invoiceId_idx" ON "attachments"("invoiceId");

-- CreateIndex
CREATE INDEX "attachments_supplierId_idx" ON "attachments"("supplierId");

-- CreateIndex
CREATE INDEX "audit_logs_entityType_entityId_idx" ON "audit_logs"("entityType", "entityId");

-- CreateIndex
CREATE INDEX "audit_logs_userId_createdAt_idx" ON "audit_logs"("userId", "createdAt");

-- AddForeignKey
ALTER TABLE "users" ADD CONSTRAINT "users_departmentId_fkey" FOREIGN KEY ("departmentId") REFERENCES "departments"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_role_assignments" ADD CONSTRAINT "user_role_assignments_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "employees" ADD CONSTRAINT "employees_departmentId_fkey" FOREIGN KEY ("departmentId") REFERENCES "departments"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "material_requests" ADD CONSTRAINT "material_requests_departmentId_fkey" FOREIGN KEY ("departmentId") REFERENCES "departments"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "material_requests" ADD CONSTRAINT "material_requests_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "material_request_items" ADD CONSTRAINT "material_request_items_materialRequestId_fkey" FOREIGN KEY ("materialRequestId") REFERENCES "material_requests"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "procurements" ADD CONSTRAINT "procurements_departmentId_fkey" FOREIGN KEY ("departmentId") REFERENCES "departments"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "procurements" ADD CONSTRAINT "procurements_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "procurement_material_requests" ADD CONSTRAINT "procurement_material_requests_procurementId_fkey" FOREIGN KEY ("procurementId") REFERENCES "procurements"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "procurement_material_requests" ADD CONSTRAINT "procurement_material_requests_materialRequestId_fkey" FOREIGN KEY ("materialRequestId") REFERENCES "material_requests"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "procurement_items" ADD CONSTRAINT "procurement_items_procurementId_fkey" FOREIGN KEY ("procurementId") REFERENCES "procurements"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "procurement_items" ADD CONSTRAINT "procurement_items_materialRequestItemId_fkey" FOREIGN KEY ("materialRequestItemId") REFERENCES "material_request_items"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "administrative_specifications" ADD CONSTRAINT "administrative_specifications_procurementId_fkey" FOREIGN KEY ("procurementId") REFERENCES "procurements"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "contract_drafts" ADD CONSTRAINT "contract_drafts_procurementId_fkey" FOREIGN KEY ("procurementId") REFERENCES "procurements"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "rfqs" ADD CONSTRAINT "rfqs_procurementId_fkey" FOREIGN KEY ("procurementId") REFERENCES "procurements"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "rfqs" ADD CONSTRAINT "rfqs_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "rfq_suppliers" ADD CONSTRAINT "rfq_suppliers_rfqId_fkey" FOREIGN KEY ("rfqId") REFERENCES "rfqs"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "rfq_suppliers" ADD CONSTRAINT "rfq_suppliers_supplierId_fkey" FOREIGN KEY ("supplierId") REFERENCES "suppliers"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "rfq_items" ADD CONSTRAINT "rfq_items_rfqId_fkey" FOREIGN KEY ("rfqId") REFERENCES "rfqs"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "rfq_items" ADD CONSTRAINT "rfq_items_procurementItemId_fkey" FOREIGN KEY ("procurementItemId") REFERENCES "procurement_items"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "quotations" ADD CONSTRAINT "quotations_rfqId_fkey" FOREIGN KEY ("rfqId") REFERENCES "rfqs"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "quotations" ADD CONSTRAINT "quotations_supplierId_fkey" FOREIGN KEY ("supplierId") REFERENCES "suppliers"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "quotations" ADD CONSTRAINT "quotations_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "quotation_items" ADD CONSTRAINT "quotation_items_quotationId_fkey" FOREIGN KEY ("quotationId") REFERENCES "quotations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "quotation_items" ADD CONSTRAINT "quotation_items_rfqItemId_fkey" FOREIGN KEY ("rfqItemId") REFERENCES "rfq_items"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "evaluations" ADD CONSTRAINT "evaluations_quotationId_fkey" FOREIGN KEY ("quotationId") REFERENCES "quotations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "evaluations" ADD CONSTRAINT "evaluations_evaluatorId_fkey" FOREIGN KEY ("evaluatorId") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "procurement_decisions" ADD CONSTRAINT "procurement_decisions_procurementId_fkey" FOREIGN KEY ("procurementId") REFERENCES "procurements"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "procurement_decision_items" ADD CONSTRAINT "procurement_decision_items_decisionId_fkey" FOREIGN KEY ("decisionId") REFERENCES "procurement_decisions"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "procurement_decision_items" ADD CONSTRAINT "procurement_decision_items_procurementItemId_fkey" FOREIGN KEY ("procurementItemId") REFERENCES "procurement_items"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "procurement_decision_items" ADD CONSTRAINT "procurement_decision_items_supplierId_fkey" FOREIGN KEY ("supplierId") REFERENCES "suppliers"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "procurement_decision_items" ADD CONSTRAINT "procurement_decision_items_quotationId_fkey" FOREIGN KEY ("quotationId") REFERENCES "quotations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "procurement_decision_items" ADD CONSTRAINT "procurement_decision_items_quotationItemId_fkey" FOREIGN KEY ("quotationItemId") REFERENCES "quotation_items"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "signatures" ADD CONSTRAINT "signatures_procurementId_fkey" FOREIGN KEY ("procurementId") REFERENCES "procurements"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "signatures" ADD CONSTRAINT "signatures_decisionId_fkey" FOREIGN KEY ("decisionId") REFERENCES "procurement_decisions"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "signatures" ADD CONSTRAINT "signatures_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "purchase_orders" ADD CONSTRAINT "purchase_orders_procurementId_fkey" FOREIGN KEY ("procurementId") REFERENCES "procurements"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "purchase_orders" ADD CONSTRAINT "purchase_orders_supplierId_fkey" FOREIGN KEY ("supplierId") REFERENCES "suppliers"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "purchase_orders" ADD CONSTRAINT "purchase_orders_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "purchase_order_items" ADD CONSTRAINT "purchase_order_items_purchaseOrderId_fkey" FOREIGN KEY ("purchaseOrderId") REFERENCES "purchase_orders"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "purchase_order_items" ADD CONSTRAINT "purchase_order_items_procurementItemId_fkey" FOREIGN KEY ("procurementItemId") REFERENCES "procurement_items"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "purchase_deliveries" ADD CONSTRAINT "purchase_deliveries_purchaseOrderId_fkey" FOREIGN KEY ("purchaseOrderId") REFERENCES "purchase_orders"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "purchase_deliveries" ADD CONSTRAINT "purchase_deliveries_receivedByEmployeeId_fkey" FOREIGN KEY ("receivedByEmployeeId") REFERENCES "employees"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "purchase_delivery_items" ADD CONSTRAINT "purchase_delivery_items_deliveryId_fkey" FOREIGN KEY ("deliveryId") REFERENCES "purchase_deliveries"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "purchase_delivery_items" ADD CONSTRAINT "purchase_delivery_items_purchaseOrderItemId_fkey" FOREIGN KEY ("purchaseOrderItemId") REFERENCES "purchase_order_items"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "invoices" ADD CONSTRAINT "invoices_supplierId_fkey" FOREIGN KEY ("supplierId") REFERENCES "suppliers"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "invoices" ADD CONSTRAINT "invoices_purchaseOrderId_fkey" FOREIGN KEY ("purchaseOrderId") REFERENCES "purchase_orders"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "attachments" ADD CONSTRAINT "attachments_procurementId_fkey" FOREIGN KEY ("procurementId") REFERENCES "procurements"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "attachments" ADD CONSTRAINT "attachments_materialRequestId_fkey" FOREIGN KEY ("materialRequestId") REFERENCES "material_requests"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "attachments" ADD CONSTRAINT "attachments_administrativeSpecificationId_fkey" FOREIGN KEY ("administrativeSpecificationId") REFERENCES "administrative_specifications"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "attachments" ADD CONSTRAINT "attachments_contractDraftId_fkey" FOREIGN KEY ("contractDraftId") REFERENCES "contract_drafts"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "attachments" ADD CONSTRAINT "attachments_rfqId_fkey" FOREIGN KEY ("rfqId") REFERENCES "rfqs"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "attachments" ADD CONSTRAINT "attachments_quotationId_fkey" FOREIGN KEY ("quotationId") REFERENCES "quotations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "attachments" ADD CONSTRAINT "attachments_evaluationId_fkey" FOREIGN KEY ("evaluationId") REFERENCES "evaluations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "attachments" ADD CONSTRAINT "attachments_decisionId_fkey" FOREIGN KEY ("decisionId") REFERENCES "procurement_decisions"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "attachments" ADD CONSTRAINT "attachments_purchaseOrderId_fkey" FOREIGN KEY ("purchaseOrderId") REFERENCES "purchase_orders"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "attachments" ADD CONSTRAINT "attachments_deliveryId_fkey" FOREIGN KEY ("deliveryId") REFERENCES "purchase_deliveries"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "attachments" ADD CONSTRAINT "attachments_invoiceId_fkey" FOREIGN KEY ("invoiceId") REFERENCES "invoices"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "attachments" ADD CONSTRAINT "attachments_supplierId_fkey" FOREIGN KEY ("supplierId") REFERENCES "suppliers"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "audit_logs" ADD CONSTRAINT "audit_logs_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;
